#requires -version 5.1

<#
.SYNOPSIS
    Publishes documentation from the BIMTools source repository to the Jekyll website repository.

.DESCRIPTION
    This script automates the process of collecting and restructuring documentation files.
    It uses the 'title' from each command's 'front-matter.yaml' as the single source of truth
    to generate URL-friendly names (slugs) in kebab-case.

    The script performs the following actions for each command:
    1. Pre-scans all 'front-matter.yaml' files to detect duplicate titles and stops if any are found.
    2. Parses App.cs (via Get-RibbonOrder) to derive ribbon panel, order, and separator info.
    3. Reads the 'title' and optional 'parent' override from 'front-matter.yaml'.
       If no 'parent' override: the ribbon panel name is used as the parent discipline.
    4. Generates a kebab-case slug (e.g., 'assign-circuit-to-conduits').
    5. Extracts the first paragraph from En.md and Es.md as descriptions.
    6. Generates 'index.md' in 'docs/<slug>/' with all front-matter fields.
    7. Copies Logo.png (from Docs/) to 'docs/<slug>/logo.png'; adds 'icon' field if present.
    8. Copies language-specific content to '_i18n/' (ignoring Ru.md), inserting a TOC snippet.
    9. Copies all other assets (images, etc.) to the command's dest folder.
    10. Warns if any expected language content files (En.md, Es.md) are missing.

.PARAMETER SourceRoot
    The absolute path to the source directory containing the command folders.

.PARAMETER DestRoot
    The absolute path to the destination Jekyll project root directory.
#>
param(
    [string]$SourceRoot = "C:\Users\1M06174\OneDrive - SENER\repos\BIMTools\BIMTools",
    [string]$DestRoot = "C:\Users\1M06174\OneDrive - SENER\repos\BIMTools\publish\SnrBim.github.io"
)

# ---------------------------------------------------------------------------
# Helper: extract the first non-heading paragraph from a markdown file
# ---------------------------------------------------------------------------
function Get-FirstParagraph($FilePath) {
    if (-not (Test-Path $FilePath)) { return $null }
    foreach ($line in (Get-Content -Path $FilePath)) {
        $t = $line.Trim()
        if ($t -ne "" -and -not $t.StartsWith("#")) { return $t }
    }
    return $null
}

# ---------------------------------------------------------------------------
# Helper: parse App.cs and return a hashtable keyed by PascalCase class prefix
# (the namespace prefix before ".Command", e.g. "Purge", "AssignConduitToCircuit")
# Each value is a hashtable:
#   Panel          - ribbon panel name as written in App.cs (e.g. "General", "MEP mechanical")
#   Order          - 1-based position within the panel (split-button sub-items count as one slot)
#   SeparatorBefore - $true if preceded by panel.AddSeparator()
# ---------------------------------------------------------------------------
function Get-RibbonOrder {
    param([string]$AppCsPath)

    $result = [ordered]@{}

    if (-not (Test-Path $AppCsPath)) {
        Write-Warning "App.cs not found at '$AppCsPath'. Ribbon order will not be injected."
        return $result
    }

    $lines        = Get-Content -Path $AppCsPath
    $currentPanel = $null
    $globalOrder  = 0          # increments across ALL panels — fixes Liquid sort order
    $nextSep      = $false
    # No seenPrefixes dedup — each unique prefix.commandClass gets its own entry
    # (handles split-buttons and multi-command folders like TransferLightingDataToSpace)

    foreach ($line in $lines) {
        $trimmed = $line.Trim()

        # Skip fully-commented lines
        if ($trimmed.StartsWith("//")) { continue }
        # Strip inline comments
        $codePart = ($trimmed -split '//', 2)[0].Trim()

        # Detect panel section: panelName = "..."  or  panelName = $"General{...}"
        if ($codePart -match 'panelName\s*=\s*["\$]"?([^"${}]+)') {
            $currentPanel = $Matches[1].Trim()
            $nextSep      = $false
            continue
        }

        if ($null -eq $currentPanel) { continue }

        # Detect separator
        if ($codePart -match 'AddSeparator\s*\(') {
            $nextSep = $true
            continue
        }

        # Detect CreateButton call (panel or splitButton host, any Command* suffix)
        if ($codePart -match 'CreateButton\s*\(.*new\s+(\w+)\.(Command\w*)') {
            $prefix       = $Matches[1]
            $commandClass = $Matches[2]
            $key          = "$prefix.$commandClass"

            if (-not $result.Contains($key)) {
                $globalOrder++
                $result[$key] = @{
                    Panel           = $currentPanel
                    Order           = $globalOrder
                    SeparatorBefore = $nextSep
                    CommandClass    = $commandClass
                    FolderPrefix    = $prefix
                }
            }
            $nextSep = $false
            continue
        }
    }

    return $result
}

# ---------------------------------------------------------------------------
# Helper: parse ButtonText from Command*.cs files
# Parses actual class names from C# source (handles files with multiple classes).
# Returns hashtable keyed by "FolderName.ClassName" -> ButtonText (preserving \n)
# ---------------------------------------------------------------------------
function Get-ButtonTexts {
    param([string]$SourceRoot)

    $result  = @{}
    $csFiles = Get-ChildItem -Path $SourceRoot -Recurse -Filter 'Command*.cs' |
               Where-Object { $_.Directory.Name -notmatch '^(bin|obj)$' }

    foreach ($file in $csFiles) {
        $folderName   = $file.Directory.Name
        $currentClass = $null
        foreach ($line in (Get-Content $file.FullName)) {
            if ($line -match 'class\s+(Command\w*)') {
                $currentClass = $Matches[1]
            }
            if ($currentClass -and $line -match 'ButtonText\s*=>\s*"([^"]+)"') {
                $result["$folderName.$currentClass"] = $Matches[1]  # keep raw \n
                $currentClass = $null  # each class has one ButtonText
            }
        }
    }

    return $result
}


# ---------------------------------------------------------------------------
# Main Script
# ---------------------------------------------------------------------------

Write-Host "Starting documentation publishing process..." -ForegroundColor Green
Write-Host "Source: $SourceRoot"
Write-Host "Destination: $DestRoot"

# --- Load ribbon order from App.cs ---
$appCsPath   = Join-Path $SourceRoot "App.cs"
$ribbonOrder = Get-RibbonOrder -AppCsPath $appCsPath
if ($ribbonOrder.Count -gt 0) {
    Write-Host "`nLoaded ribbon order for $($ribbonOrder.Count) commands from App.cs." -ForegroundColor Cyan
} else {
    Write-Warning "Ribbon order could not be loaded. 'ribbon_panel', 'ribbon_order', and 'icon' fields will be omitted."
}

# --- Load button texts from Command*.cs files ---
$buttonTexts = Get-ButtonTexts -SourceRoot $SourceRoot
Write-Host "Loaded button texts for $($buttonTexts.Count) command variants." -ForegroundColor Cyan

$commandFolders = Get-ChildItem -Path $SourceRoot -Directory | Where-Object {
    ($_.Name -ne "Template") -and ($_.Name -ne "Manifest") -and ($_.Name -ne "Res") -and ($_.Name -ne "Properties") -and ($_.Name -ne "bin") -and ($_.Name -ne "obj") -and (Test-Path -Path (Join-Path $_.FullName "Docs"))
}

if (-not $commandFolders) {
    Write-Warning "No command folders with a 'Docs' subdirectory found in '$SourceRoot'."
    exit
}

# --- Pre-flight Check for Duplicate Titles ---
$titleRegistry = @{}
$duplicateTitles = @{}
Write-Host "`nScanning for titles and checking for duplicates..." -ForegroundColor Cyan

foreach ($commandFolder in $commandFolders) {
    $frontMatterPath = Join-Path $commandFolder.FullName "Docs\front-matter.yaml"
    if (-not (Test-Path $frontMatterPath)) { continue }

    $titleLine = Get-Content $frontMatterPath | Select-String -Pattern "^title:"
    if (-not $titleLine) { continue }

    $title = ($titleLine.Line -split ':', 2)[1].Trim()

    if ($titleRegistry.ContainsKey($title)) {
        if (-not $duplicateTitles.ContainsKey($title)) {
            $duplicateTitles[$title] = @($titleRegistry[$title], $commandFolder.Name)
        } else {
            $duplicateTitles[$title] += $commandFolder.Name
        }
    } else {
        $titleRegistry[$title] = $commandFolder.Name
    }
}

if ($duplicateTitles.Count -gt 0) {
    Write-Error "CRITICAL: Duplicate titles found! This will cause pages to overwrite each other. Please ensure all command titles in 'front-matter.yaml' are unique."
    foreach ($title in $duplicateTitles.Keys) {
        $folderList = $duplicateTitles[$title] -join ", "
        Write-Error "  - Title: '$title' was found in folders: $folderList"
    }
    exit 1
}

Write-Host "No duplicate titles found. Proceeding with publishing." -ForegroundColor Green
# --- End of Pre-flight Check ---


Write-Host "`nFound commands to process: $($commandFolders.Count)."

$tocSnippetEn = @"
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

"@

$tocSnippetEs = @"
{: .no_toc }

<details open markdown="block">
  <summary>
    Tabla de contenidos
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

"@

foreach ($commandFolder in $commandFolders) {
    $isWip = $false
    $commandNamePascalCase = $commandFolder.Name
    $sourceDocsPath = Join-Path $commandFolder.FullName "Docs"
    $frontMatterPath = Join-Path $sourceDocsPath "front-matter.yaml"

    if (-not (Test-Path $frontMatterPath)) {
        Write-Warning "  front-matter.yaml not found in '$sourceDocsPath' for command '$commandNamePascalCase'. Skipping."
        continue
    }

    $titleLine = Get-Content $frontMatterPath | Select-String -Pattern "^title:"
    if (-not $titleLine) {
        Write-Warning "  'title:' not found in '$frontMatterPath' for command '$commandNamePascalCase'. Skipping."
        continue
    }

    $title = ($titleLine.Line -split ':', 2)[1].Trim()

    # Skip template if it somehow got through filters
    if ($title -eq "Command Title Placeholder") {
        Write-Host "  Skipping placeholder template." -ForegroundColor Gray
        continue
    }

    $slug = $title.ToLower() -replace '[^a-z0-9\s-]', '' -replace '\s+', '-'

    if ([string]::IsNullOrWhiteSpace($slug)) {
        Write-Warning "  Could not generate a URL slug from title: '$title'. Skipping."
        continue
    }

    # --- Resolve ribbon info for this command ---
    # Find all ribbon entries for this folder, sorted by global order
    $allRibbonKeys = @($ribbonOrder.Keys |
        Where-Object { $ribbonOrder[$_].FolderPrefix -eq $commandNamePascalCase } |
        Sort-Object { $ribbonOrder[$_].Order })
    $ribbonInfo  = if ($allRibbonKeys.Count -ge 1) { $ribbonOrder[$allRibbonKeys[0]] } else { $null }
    $ribbonInfo2 = if ($allRibbonKeys.Count -ge 2) { $ribbonOrder[$allRibbonKeys[1]] } else { $null }

    Write-Host "`nProcessing command: $commandNamePascalCase" -ForegroundColor Yellow
    Write-Host "  Generated slug from title: $slug"
    if ($ribbonInfo) {
        Write-Host "  Ribbon: panel='$($ribbonInfo.Panel)', order=$($ribbonInfo.Order), sep=$($ribbonInfo.SeparatorBefore)"
    } else {
        Write-Host "  Ribbon: not found in App.cs" -ForegroundColor DarkGray
    }

    $destCommandRootPath = Join-Path $DestRoot "docs\$slug"
    $destI18nEnPath = Join-Path $DestRoot "_i18n\en\docs"
    $destI18nEsPath = Join-Path $DestRoot "_i18n\es\docs"

    if (-not (Test-Path $destCommandRootPath)) {
        New-Item -ItemType Directory -Path $destCommandRootPath -Force | Out-Null
        Write-Host "  Created directory: $destCommandRootPath"
    }
    if (-not (Test-Path $destI18nEnPath)) { New-Item -ItemType Directory -Path $destI18nEnPath -Force | Out-Null }
    if (-not (Test-Path $destI18nEsPath)) { New-Item -ItemType Directory -Path $destI18nEsPath -Force | Out-Null }

    $sourceFiles = Get-ChildItem -Path $sourceDocsPath -File
    $foundEn = $false
    $foundEs = $false
    $esFileFullPath = $null

    foreach ($file in $sourceFiles) {
        $destPath = ""
        switch -Wildcard ($file.Name) {
            "En.md" {
                $foundEn = $true
                $destPath = Join-Path $destI18nEnPath "$slug.md"

                $content = Get-Content -Path $file.FullName -Raw
                $insertPosition = $content.IndexOf("`n") + 1
                if ($insertPosition -eq 0) {
                    $newContent = $content + "`n" + $tocSnippetEn
                } else {
                    $newContent = $content.Insert($insertPosition, $tocSnippetEn)
                }
                Set-Content -Path $destPath -Value $newContent -Force

                Write-Host "  Copied content with TOC to -> $destPath"

                $firstLine = Get-Content -Path $file.FullName -TotalCount 1
                if ($firstLine -eq "# English Command Title") {
                    $isWip = $true
                    Write-Host "  Marked as WIP (Work In Progress)." -ForegroundColor Magenta
                }
            }
            "Es.md" {
                $foundEs = $true
                $esFileFullPath = $file.FullName
                $destPath = Join-Path $destI18nEsPath "$slug.md"

                $content = Get-Content -Path $file.FullName -Raw
                $insertPosition = $content.IndexOf("`n") + 1
                if ($insertPosition -eq 0) {
                    $newContent = $content + "`n" + $tocSnippetEs
                } else {
                    $newContent = $content.Insert($insertPosition, $tocSnippetEs)
                }
                Set-Content -Path $destPath -Value $newContent -Force

                Write-Host "  Copied content with TOC to -> $destPath"
            }
            "Ru.md" {
                Write-Host "  Ignoring file: $($file.Name)" -ForegroundColor Gray
            }
            "front-matter.yaml" {
                $destPath = Join-Path $destCommandRootPath "index.md"

                # Get descriptions
                $enMdPath      = Join-Path $sourceDocsPath "En.md"
                $esMdPath      = Join-Path $sourceDocsPath "Es.md"
                $enDescription = Get-FirstParagraph -FilePath $enMdPath
                $esDescription = Get-FirstParagraph -FilePath $esMdPath

                $originalLines        = Get-Content -Path $file.FullName
                $endFrontMatterIndex  = [array]::IndexOf($originalLines, '---', 1)
                if ($endFrontMatterIndex -lt 0) { $endFrontMatterIndex = $originalLines.Count }

                $newFrontMatterLines = [System.Collections.Generic.List[string]]::new()
                $newFrontMatterLines.Add('---')

                # Carry over source lines, filtering all script-managed fields.
                # 'parent' in front-matter.yaml is treated as an explicit override;
                # if absent, it will be set from the ribbon panel below.
                $hasParentOverride = $false
                for ($i = 1; $i -lt $endFrontMatterIndex; $i++) {
                    $l = $originalLines[$i]
                    if ($l -match "^(namespace|permalink|layout|wip|description|description_es|ribbon_panel|ribbon_order|ribbon_order_2|ribbon_separator_before|ribbon_button_text|ribbon_button_text_2|icon):") {
                        continue  # always regenerated
                    }
                    if ($l -match "^parent:") {
                        $hasParentOverride = $true
                    }
                    $newFrontMatterLines.Add($l)
                }

                # If no manual parent, derive from ribbon panel
                if (-not $hasParentOverride -and $ribbonInfo) {
                    $newFrontMatterLines.Add("parent: $($ribbonInfo.Panel)")
                }

                # Managed / generated fields
                $newFrontMatterLines.Add("layout: default")
                if ($isWip) { $newFrontMatterLines.Add("wip: true") }
                if ($enDescription) {
                    $newFrontMatterLines.Add("description: '$($enDescription -replace "'", "''")'")
                }
                if ($esDescription) {
                    $newFrontMatterLines.Add("description_es: '$($esDescription -replace "'", "''")'")
                }

                # Ribbon fields
                if ($ribbonInfo) {
                    $newFrontMatterLines.Add("ribbon_panel: $($ribbonInfo.Panel)")
                    $newFrontMatterLines.Add("ribbon_order: $($ribbonInfo.Order)")
                    if ($ribbonInfo.SeparatorBefore) {
                        $newFrontMatterLines.Add("ribbon_separator_before: true")
                    }
                    $btnText = $buttonTexts["$commandNamePascalCase.$($ribbonInfo.CommandClass)"]
                    if ($btnText) {
                        $newFrontMatterLines.Add("ribbon_button_text: `"$($btnText -replace '"', '\"')`"")
                    }
                    # Secondary button (e.g. TransferLightingDataToSpace has CommandNormal + CommandEmergency)
                    if ($ribbonInfo2) {
                        $newFrontMatterLines.Add("ribbon_order_2: $($ribbonInfo2.Order)")
                        $btnText2 = $buttonTexts["$commandNamePascalCase.$($ribbonInfo2.CommandClass)"]
                        if ($btnText2) {
                            $newFrontMatterLines.Add("ribbon_button_text_2: `"$($btnText2 -replace '"', '\"')`"")
                        }
                    }
                }

                # Icon: copy Logo.png from Docs/ if present
                $sourceLogoPath = Join-Path $sourceDocsPath "Logo.png"
                if (Test-Path $sourceLogoPath) {
                    $destLogoPath = Join-Path $destCommandRootPath "logo.png"
                    Copy-Item -Path $sourceLogoPath -Destination $destLogoPath -Force
                    $newFrontMatterLines.Add("icon: /docs/$slug/logo.png")
                    Write-Host "  Copied Logo.png -> $destLogoPath"
                } else {
                    Write-Warning "  Logo.png not found in '$sourceDocsPath'. No icon will be set."
                }

                $newFrontMatterLines.Add("namespace: $slug")
                $newFrontMatterLines.Add("permalink: /docs/$slug/")
                $newFrontMatterLines.Add('---')
                $newFrontMatterLines.Add("{% include ribbon_context.html %}")
                $newFrontMatterLines.Add("{% translate_file docs/$slug.md %}")

                Set-Content -Path $destPath -Value $newFrontMatterLines
                Write-Host "  Generated index.md -> $destPath"
            }
            "Logo.png" {
                # Handled inside the front-matter.yaml case above; skip here to avoid double-copy
                Write-Host "  Skipping Logo.png (handled via front-matter pass)." -ForegroundColor Gray
            }
            default {
                $destPath = Join-Path $destCommandRootPath $file.Name
                Copy-Item -Path $file.FullName -Destination $destPath -Force
                Write-Host "  Copied asset to -> $destPath"
            }
        }
    }

    if (-not $foundEn) {
        if ($foundEs) {
            $destEnPath = Join-Path $destI18nEnPath "$slug.md"
            Copy-Item -Path $esFileFullPath -Destination $destEnPath -Force
            Write-Warning "  WARNING: English content (En.md) not found for '$commandNamePascalCase'. Using Spanish version as a fallback."
        }
        else {
            Write-Warning "  WARNING: English content (En.md) was not found for command '$commandNamePascalCase'. The English page might be empty or missing."
        }
    }
    if (-not $foundEs) {
        Write-Warning "  WARNING: Spanish content (Es.md) was not found for command '$commandNamePascalCase'. The Spanish page might be empty or missing."
    }
}

Write-Host "`nDocumentation publishing finished." -ForegroundColor Green
