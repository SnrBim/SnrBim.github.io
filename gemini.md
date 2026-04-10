# Gemini Agent Instructions for SnrBim.github.io

This file provides context and instructions for the Gemini AI agent.

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

To run the documentation site locally for previewing changes, follow these steps precisely.

**Prerequisites:** A portable version of Ruby with DevKit is located at `C:\Users\1M06174\ruby\rubyinstaller-3.4.7-1-x64`.

**Steps to run the local server:**

1.  Open a new PowerShell terminal.
2.  Navigate to the website's project directory:
    ```powershell
    cd C:\Users\1M06174\source\repos\BIMTools\publish\SnrBim.github.io\
    ```
3.  **Synchronize documentation:** Run the publishing script to copy the latest documentation from the main `BIMTools` repository.
    ```powershell
    .\Publish-Docs.ps1
    ```
4.  **Activate the Ruby environment.** This step is crucial because the Ruby installation is portable.
    ```powershell
    $env:PATH = "C:\Users\1M06174\ruby\rubyinstaller-3.4.9-1-x64\bin;" + $env:PATH
    ```
5.  Run the Jekyll server:
    ```powershell
    bundle exec jekyll serve
    ```
6.  The site will be available at **http://127.0.0.1:4000/**. The server will auto-regenerate when you save changes to any source files *within this project*, but you must re-run `Publish-Docs.ps1` to see changes from the source repository.

## Documentation Publishing Workflow (`Publish-Docs.ps1`)

The content for the documentation is not stored in this repository directly. It is aggregated from the main `BIMTools` repository using the `Publish-Docs.ps1` script.

### Source Structure Convention

For the script to work, each command's documentation in the `BIMTools` repository **must** follow this structure:

*   The source folder is named in `PascalCase` (e.g., `AssignConduitToCircuit`).
*   Inside this folder, there must be a `Docs` subdirectory.
*   The `Docs` subdirectory contains:
    *   `front-matter.yaml`: A YAML file containing at least the `title`.
    *   `En.md`: The English content for the page.
    *   `Es.md`: The Spanish content for the page.
    *   Any assets (like `pic1.png`) used by the documentation.

Example:
```
BIMTools\
└── AssignConduitToCircuit\
    └── Docs\
        ├── En.md
        ├── Es.md
        ├── front-matter.yaml
        └── pic1.png
```

### Source Structure Convention (updated)

Помимо ранее описанных файлов, скрипт теперь использует:
*   `Logo.png` — иконка команды, расположенная в `<Command>/Docs/Logo.png`. Скрипт копирует её в `docs/<slug>/logo.png` и добавляет поле `icon` в front-matter.

### Script Automation Logic

When you run `.\Publish-Docs.ps1`, it performs the following for each command found:

1.  **Parses `App.cs`** (`Get-RibbonOrder`): reads the Revit ribbon structure and builds a map of `ClassName → { Panel, GlobalOrder, SeparatorBefore, CommandClass }`. The order counter is **global across all panels**, so Liquid's `sort: "ribbon_order"` reproduces the exact Revit panel sequence.
2.  **Parses `Command*.cs`** (`Get-ButtonTexts`): reads `ButtonText` from each command class (preserving `\n`). Key format: `"FolderName.CommandClass"`.
3.  **Reads `title`** from `front-matter.yaml`; generates a kebab-case slug.
4.  **Checks for duplicate titles** — aborts if found.
5.  **Generates `docs/<slug>/index.md`** with all front-matter fields:
    *   Fields carried from `front-matter.yaml`: `title`, manual `parent` override (if present).
    *   Auto-derived: `parent` (from ribbon panel name, if no manual override), `layout`, `wip`, `description`, `description_es`.
    *   Ribbon fields: `ribbon_panel`, `ribbon_order`, `ribbon_separator_before` (only if true), `ribbon_button_text` (double-quoted YAML so `\n` becomes a real newline).
    *   `icon: /docs/<slug>/logo.png` — only if `Docs/Logo.png` exists.
    *   `namespace`, `permalink`.
6.  **Copies `Docs/Logo.png`** → `docs/<slug>/logo.png` (handled inside the `front-matter.yaml` switch case; `Logo.png` case skips to avoid duplication).
7.  **Injects TOC and copies content** of `En.md` / `Es.md` to `_i18n/<lang>/docs/<slug>.md`.
8.  **Copies other assets** (images etc.) to `docs/<slug>/`.
9.  **Warns** on missing `En.md`, `Es.md`, or `Logo.png`.

## Deployment Workflow

1.  **Update Content:** Before committing, ensure the latest documentation is pulled into the project by running the publishing script from the project root:
    ```powershell
    .\Publish-Docs.ps1
    ```
2.  **Commit and Push:** Commit the changes (which will include all the files generated by the script) and push them to the `main` branch.
3.  **Automatic Deployment:** Any changes pushed to the `main` branch will be automatically deployed to the live site by GitHub Pages.

## Multilingual Setup (jekyll-multiple-languages-plugin)

This project uses the `kurtsson/jekyll-multiple-languages-plugin` to manage content in multiple languages (en, es). The `Publish-Docs.ps1` script automates the creation of the necessary file structure for this plugin to work.

### Key Concepts:

*   **Language Files:** All translations for UI strings are stored in `.yml` files inside the `_i18n/` directory (e.g., `_i18n/en.yml`, `_i18n/es.yml`).
*   **Page Content:** The script places language-specific content into `_i18n/<lang>/docs/<slug>.md`.
*   **Template Pages:** The script generates template pages at `docs/<slug>/index.md`. These contain the front-matter needed to link the different language versions and a `{% translate_file %}` tag to include the actual content.
*   **Language Switcher:** The language switcher links are configured in `_config.yml` under `aux_links`. The switching logic is handled by the `initLangSwither` JavaScript function in `_includes/footer_custom.html`.

---

### Important Note on `default_locale_in_subfolder`

The configuration `default_locale_in_subfolder: true` **must not be used** in the current setup.

**Reason:**
This setting triggers a specific code path in the `jekyll-multiple-languages-plugin` (version 1.8.0) that handles the creation of a subfolder for the default language. This part of the plugin's code contains a call to `Dir.exists?`, a method that has been removed in modern versions of Ruby (the project uses Ruby 3.4.7).

Using this setting will cause the Jekyll build to fail with a `NoMethodError: undefined method 'exists?' for class Dir`.

To resolve this, one would need to either:
1.  Patch the plugin's code and set up a GitHub Actions workflow to build the site outside of GitHub Pages' `safe` mode.
2.  Migrate to a modern, maintained multilingual plugin like `jekyll-polyglot`.

Until then, the default language (`en`) will be served from the root of the website, and other languages will be in subfolders.

## Key Files

*   **`index.md`**: The main page. Contains Liquid logic for the filterable command list and includes the ribbon replica (`{% include ribbon.html %}`). Loads `assets/css/commands.css` and `assets/js/commands.js`. Logic handles `wip: true` (no link). Icons (`doc-icon`) are shown only in the ribbon, not in the alphabetical list.
*   **`_includes/ribbon.html`**: Renders the Revit ribbon replica. Sorts all commands globally by `ribbon_order`, derives panel display order from first occurrence, renders panels as horizontal rows with a vertical label on the left. WIP buttons render as `<span>` (no link), dimmed, with a tooltip. Button label uses `ribbon_button_text` (with `\n` → real newline via `white-space: pre`).
*   **`_includes/ribbon_context.html`**: Mini-ribbon floated right on command pages. Shows a **±2 global window** of commands around the current one, across all panels. Grouped by panel: buttons rendered above, panel name centered below (horizontal). "…" ellipsis shown at left/right edges when window is cut off. Commands with `ribbon_order_2` count as 1 position but render both buttons. Three passes: (1) find `cur_idx` by `namespace`, (2) compute `win_start/win_end`, (3) collect `win_panels` then render per-panel groups.
*   **`assets/css/commands.css`**: All styles for the main page and command pages: command list items, collapsible descriptions, ribbon layout, button appearance (`#F5F5F5` default, `#DDDDDD` hover, black text, `white-space: pre` for labels), WIP dimming. Context ribbon classes: `.ribbon-context` (float right, `background-color: #F5F5F5`, `z-index: 10`, no `max-width`), `.ribbon-context-row` (flex row for groups + ellipsis), `.ribbon-context-group` (flex column, `border-right` separator, `min-width: 0`), `.ribbon-context .ribbon-panel-name` (override: `writing-mode: horizontal-tb`, centered, no border).
*   **`assets/js/commands.js`**: Three isolated functions — `initFilter` (discipline checkboxes), `initCollapsibleDescriptions` (animated details/summary), `initRibbonHover` (mutual highlight between ribbon buttons and list items via `data-slug`).
*   **`docs/1Common.md`, `docs/2MEC.md`, `docs/3ELE.md`, `docs/4Misc.md`**: Discipline parent pages (`has_children: true`). Panel name from `App.cs` must match the `title` of the corresponding discipline page for the `parent` field to work correctly.
*   **`Publish-Docs.ps1`**: See «Script Automation Logic» above.
*   **`_includes/footer_custom.html`**: Global scripts — language switcher and theme toggle.
*   **`_i18n/en.yml`, `_i18n/es.yml`**: UI strings. Keys `discipline.*` and `discipline_short.*` must cover all ribbon panel names used as parents (currently: `General`/`common`, `MEP mechanical`/`mec`, `MEP electrical`/`ele`, `Misc`/`misc`).

### Discipline page ↔ ribbon panel name mapping

| `App.cs` panel name | `front-matter parent` value | Discipline page title | i18n key |
|---|---|---|---|
| `General` | `General` | `Common` | `common` |
| `MEP mechanical` | `MEP mechanical` | `MEC` | `mec` |
| `MEP electrical` | `MEP electrical` | `ELE` | `ele` |
| `Misc` | `Misc` | `Misc` | `misc` |

> **Note:** The `parent` value written into `front-matter` equals the raw panel name from `App.cs`. The discipline *page* `title` is separate (e.g. `Common`, not `General`). The filter checkboxes use `group.title`, so they match `Common`, `MEC`, `ELE`, `Misc`. This means that currently, commands in the `General` panel have `parent: General` which does **not** match the `Common` page title — this is a known mismatch to be resolved (either rename the Revit panel or add a panel→title mapping in the script).

---

**Work Log:** PLAN.md

---

## Технический долг и архитектурные проблемы

### Архитектурные проблемы

1.  **Ручной процесс сборки контента**: Скрипт `Publish-Docs.ps1` должен запускаться вручную на Windows. CI/CD пайплайн в GitHub Actions работает на Ubuntu и не может выполнить этот PowerShell скрипт. Это делает процесс развертывания медленным, подверженным ошибкам и зависимым от конкретной машины.
2.  **Хранение сгенерированных файлов в Git**: Репозиторий хранит файлы, которые генерируются скриптом (`docs/*/index.md`, `_i18n/*/docs/*`). Это плохая практика, так как "загрязняет" историю коммитов, увеличивает размер репозитория и усложняет разрешение конфликтов слияния. Исходный код должен быть отделен от сгенерированных артефактов.
3.  **Устаревший плагин для многоязычности**: Как указано в `GEMINI.md`, используется плагин (`jekyll-multiple-languages-plugin`), который имеет проблемы совместимости с современными версиями Ruby. Это технический долг, который может привести к полной неработоспособности сайта при обновлении зависимостей.

### Проблемы с читаемостью кода

1.  **Перегруженный `index.md`**: Файл `index.md` содержит сложную смесь из HTML, встроенных стилей (CSS) и логики на JavaScript. Это нарушает принцип разделения ответственности (separation of concerns) и делает файл трудным для чтения и поддержки. Стили и скрипты следует вынести в отдельные файлы.
2.  **"Хрупкий" скрипт `Publish-Docs.ps1`**: Скрипт использует регулярные выражения для парсинга `front-matter.yaml`. Этот подход ненадежен и может легко сломаться при малейшем изменении формата исходных файлов. Более надежным решением было бы использование полноценного YAML-парсера.

### Рекомендации

1.  **Автоматизировать пайплайн**: Переписать `Publish-Docs.ps1` на кросс-платформенном языке (например, Python или Node.js) и встроить его в CI/CD (`deploy.yml`). Пайплайн должен будет скачивать оба репозитория, запускать скрипт для генерации контента, а затем собирать и публиковать сайт.
2.  **Очистить репозиторий**: После автоматизации пайплайна добавить все сгенерированные файлы в `.gitignore`.
3.  **Рефакторинг `index.md`**: Вынести встроенные CSS и JavaScript в отдельные файлы в папку `assets`.
4.  **Миграция на новый плагин**: Рассмотреть возможность перехода на более современный плагин для многоязычности, например `jekyll-polyglot`, чтобы устранить технический долг.