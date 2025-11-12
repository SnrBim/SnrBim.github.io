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
    2. Reads the 'title' from 'front-matter.yaml'.
    3. Generates a kebab-case slug (e.g., 'assign-circuit-to-conduits').
    4. Extracts the first paragraph from En.md and Es.md.
    5. Generates 'index.md' in the destination 'docs/<slug>/' directory. This file's front-matter
       includes the original front-matter, generated fields ('layout', 'namespace', 'permalink'),
       and the extracted 'description' and 'description_es' fields.
    6. Copies language-specific content to '_i18n/' (ignoring Ru.md).
    7. Copies all assets (images, etc.) to the asset directory.
    8. Warns if any expected language content files (En.md, Es.md) are missing for a command.

.PARAMETER SourceRoot
    The absolute path to the source directory containing the command folders.

.PARAMETER DestRoot
    The absolute path to the destination Jekyll project root directory.
#>
param(
    [string]$SourceRoot = "C:\Users\1M06174\source\repos\BIMTools\BIMTools",
    [string]$DestRoot = "C:\Users\1M06174\source\repos\BIMTools\publish\SnrBim.github.io"
)

# --- Helper Functions ---
function Get-FirstParagraph($FilePath) {
    if (-not (Test-Path $FilePath)) { return $null }

    $lines = Get-Content -Path $FilePath
    foreach ($line in $lines) {
        $trimmedLine = $line.Trim()
        # Find the first non-empty line that is not a markdown header
        if ($trimmedLine -ne "" -and -not $trimmedLine.StartsWith("#")) {
            return $trimmedLine
        }
    }
    return $null
}


# --- Main Script ---

Write-Host "Starting documentation publishing process..." -ForegroundColor Green
Write-Host "Source: $SourceRoot"
Write-Host "Destination: $DestRoot"

$commandFolders = Get-ChildItem -Path $SourceRoot -Directory | Where-Object {
    ($_.Name -ne "Template") -and (Test-Path -Path (Join-Path $_.FullName "Docs"))
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
    $slug = $title.ToLower() -replace '[^a-z0-9\s-]', '' -replace '\s+', '-'

    if ([string]::IsNullOrWhiteSpace($slug)) {
        Write-Warning "  Could not generate a URL slug from title: '$title'. Skipping."
        continue
    }

    Write-Host "`nProcessing command: $commandNamePascalCase" -ForegroundColor Yellow
    Write-Host "  Generated slug from title: $slug"

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
                
                # --- Get descriptions for injection ---
                $enMdPath = Join-Path $sourceDocsPath "En.md"
                $esMdPath = Join-Path $sourceDocsPath "Es.md"
                $enDescription = Get-FirstParagraph -FilePath $enMdPath
                $esDescription = Get-FirstParagraph -FilePath $esMdPath
                # ---

                $originalLines = Get-Content -Path $file.FullName
                $endFrontMatterIndex = [array]::IndexOf($originalLines, '---', 1)
                if ($endFrontMatterIndex -lt 0) { $endFrontMatterIndex = $originalLines.Count }

                $newFrontMatterLines = [System.Collections.Generic.List[string]]::new()
                $newFrontMatterLines.Add('---')

                # Add existing lines, filtering out script-managed fields
                for ($i = 1; $i -lt $endFrontMatterIndex; $i++) {
                    if ($originalLines[$i] -notmatch "^(namespace|permalink|layout|wip|description|description_es):") {
                        $newFrontMatterLines.Add($originalLines[$i])
                    }
                }

                # Add generated and managed fields
                $newFrontMatterLines.Add("layout: default")
                if ($isWip) {
                    $newFrontMatterLines.Add("wip: true")
                }
                if ($enDescription) {
                    $escapedDesc = $enDescription -replace "'", "''"
                    $lineToAdd = "description: '$escapedDesc'"
                    $newFrontMatterLines.Add($lineToAdd)
                }
                if ($esDescription) {
                    $escapedDesc = $esDescription -replace "'", "''"
                    $lineToAdd = "description_es: '$escapedDesc'"
                    $newFrontMatterLines.Add($lineToAdd)
                }
                $newFrontMatterLines.Add("namespace: $slug")
                $newFrontMatterLines.Add("permalink: /docs/$slug/")
                $newFrontMatterLines.Add('---')
                
                # Add the translate_file tag after the front matter
                $newFrontMatterLines.Add("{% translate_file docs/$slug.md %}")

                Set-Content -Path $destPath -Value $newFrontMatterLines
                Write-Host "  Generated front-matter with descriptions and saved to -> $destPath"
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
