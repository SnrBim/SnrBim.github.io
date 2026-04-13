# Agent Instructions for SnrBim.github.io

This file provides context and instructions for AI agents working on this project.

## Rules for Editing This File

*   Each method or file is described through its **purpose** and **decision criteria**, not its implementation.
*   Describe «what the method governs», not «how it does it».
*   Not allowed: specific colors, numbers, formats, algorithmic steps — anything that may change in code.
*   All methods are listed except obvious utilities with a narrow scope.

## Project Overview

*   **Project Name:** SnrBim.github.io
*   **Description:** The documentation website for the Sener BIMTools project, built with Jekyll and hosted on GitHub Pages.
*   **Live URL:** https://snrbim.github.io/
*   **Source Repository (for this site):** https://github.com/SnrBim/SnrBim.github.io
*   **Source Repository (for BIMTools):** https://github.com/SnrBim/BIMTools

## Key Technologies

*   **Static Site Generator:** Jekyll
*   **Theme:** just-the-docs
*   **Language:** Ruby (Portable version)

## Local Development Workflow

**Prerequisites:** A portable version of Ruby with DevKit at `C:\Users\1M06174\ruby\rubyinstaller-3.4.9-1-x64`.

```powershell
cd "C:\Users\1M06174\OneDrive - SENER\repos\BIMTools\publish\SnrBim.github.io"
.\Publish-Docs.ps1
$env:PATH = "C:\Users\1M06174\ruby\rubyinstaller-3.4.9-1-x64\bin;" + $env:PATH
bundle exec jekyll serve
```

Site available at **http://127.0.0.1:4000/**. Re-run `Publish-Docs.ps1` to pick up changes from the BIMTools source repo.

## Documentation Publishing Workflow (`Publish-Docs.ps1`)

Content is not stored in this repo — it is aggregated from the `BIMTools` repository by the script.

### Source Structure Convention

Each command folder in `BIMTools` must contain a `Docs/` subdirectory with:
*   `front-matter.yaml` — at minimum a `title` field; may contain a manual `parent` override.
*   `En.md` / `Es.md` — command documentation in English and Spanish.
*   `Logo.png` — ribbon button icon.
*   Any other assets referenced by the documentation.

### Script Functions

*   **`Get-RibbonOrder`** — determines the position and panel of each command in the Revit ribbon. Decides whether a separator is shown before a button. Position is globally unique across all panels so that commands can be sorted in Revit tab order from any template.
*   **`Get-ButtonTexts`** — determines the button label for each command, preserving multi-line labels.
*   **`Get-Slug`** — converts a command title to a URL-safe identifier used for folder names and permalinks.
*   **Main loop** — for each command: validates source structure, assembles all front-matter fields, copies assets to the output folder, and warns about missing source files.

## Deployment Workflow

1.  Run `.\Publish-Docs.ps1` to sync content from the BIMTools repo.
2.  Commit and push to `main`.
3.  GitHub Pages deploys automatically.

## Multilingual Setup (jekyll-multiple-languages-plugin)

*   UI strings: `_i18n/en.yml`, `_i18n/es.yml`.
*   Page content: `_i18n/<lang>/docs/<slug>.md` (written by the script).
*   Template pages: `docs/<slug>/index.md` — front-matter + `{% translate_file %}` tag.
*   Language switcher: `initLangSwitcher` in `_includes/footer_custom.html`.

### Important: `default_locale_in_subfolder` must remain `false`

Setting it to `true` triggers a code path in the plugin that calls a Ruby method removed in modern versions. The build will fail. To fix properly: patch the plugin or migrate to `jekyll-polyglot`.

## Key Files

*   **`index.md`** — main page. Renders the filterable command list and the ribbon replica. WIP items show a tooltip instead of inline status text. Items with descriptions show the description as a hover tooltip.
*   **`_includes/ribbon.html`** — renders the full Revit ribbon replica on the main page. Determines panel display order from the global command sort order. WIP commands are shown as non-clickable, dimmed buttons. Panel names are shortened for display; the `ribbon_panel` field in front-matter stores the original Revit name.
*   **`_includes/ribbon_context.html`** — renders a compact ribbon on command pages, showing only the commands near the current one in the global order. Commands from different panels may appear together if they are adjacent. WIP and dual-button commands are handled consistently with the main ribbon. When the window is cut off at an edge, the visual border is removed on that side to signal continuation.
*   **`_includes/head_custom.html`** — injects the global stylesheet into every page via the just-the-docs hook.
*   **`assets/css/commands.css`** — all visual rules for the command list, ribbon replica, and context ribbon. All ribbon colors are defined as CSS custom properties with dark-mode overrides.
*   **`assets/js/commands.js`** — controls three independent behaviours: discipline filter checkboxes, animated collapsible descriptions, and mutual hover highlight between ribbon buttons and list items.
*   **`docs/1Common.md`, `docs/2MEC.md`, `docs/3ELE.md`, `docs/4Misc.md`** — discipline parent pages. Each command's `parent` field must resolve to one of these page titles for sidebar navigation to work.
*   **`Publish-Docs.ps1`** — the only mechanism for syncing content from the BIMTools source repo. See «Script Functions» above.
*   **`_includes/footer_custom.html`** — global scripts: language switcher and theme toggle. The theme toggle persists the selected theme and synchronises a body marker so that custom CSS overrides in `commands.css` take effect.
*   **`_i18n/en.yml`, `_i18n/es.yml`** — UI strings, including discipline names and short labels used by the filter and sidebar.

## Dark Theme Mechanism

just-the-docs implements dark mode by swapping the active stylesheet; it does **not** set a body attribute or class. To allow `commands.css` to react to the active theme, `footer_custom.html` additionally sets a marker on `<body>` whenever the theme changes or on page load. CSS dark-mode overrides target this marker.

### Discipline page ↔ ribbon panel name mapping

| `App.cs` panel name | `parent` in front-matter | Discipline page title | i18n key |
|---|---|---|---|
| `General` | `General` | `Common` | `common` |
| `MEP mechanical` | `MEP mechanical` | `MEC` | `mec` |
| `MEP electrical` | `MEP electrical` | `ELE` | `ele` |
| `Misc` | `Misc` | `Misc` | `misc` |

> **Known mismatch:** commands in the `General` panel have `parent: General`, which does not match the discipline page title `Common`. The filter groups by page title, so these commands fall under «Other». Fix: add a panel→title mapping in `Publish-Docs.ps1`.

---

**Work Log:** PLAN.md

---

## Технический долг

1.  **Ручная сборка** — `Publish-Docs.ps1` запускается вручную на Windows; CI/CD на Ubuntu запустить его не может. Из-за этого сгенерированные файлы (`docs/*/index.md`, `_i18n/*/docs/*`) приходится коммитить — иначе они не попадут на GitHub Pages. Если перевести сборку в Actions, эти файлы можно будет исключить из репозитория.
    *   **Доступ к `BIMTools`** — для клонирования второго репозитория в Actions нужен Deploy Key (SSH read-key в `BIMTools` → Deploy keys, приватная часть как секрет в `SnrBim.github.io`). PAT тоже работает, но привязан к пользователю.
2.  **Устаревший плагин** — `jekyll-multiple-languages-plugin` несовместим с современным Ruby; риск поломки при обновлении зависимостей.
3.  **Хрупкий парсинг** — скрипт читает `front-matter.yaml` через регулярные выражения вместо YAML-парсера.
