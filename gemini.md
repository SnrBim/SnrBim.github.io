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
*   **Theme:** jekyll-theme-minimal
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
3.  **Activate the Ruby environment.** This step is crucial because the Ruby installation is portable.
    ```powershell
    $env:PATH = "C:\Users\1M06174\ruby\rubyinstaller-3.4.7-1-x64\bin;" + $env:PATH
    ```
4.  Run the Jekyll server:
    ```powershell
    bundle exec jekyll serve
    ```
5.  The site will be available at **http://127.0.0.1:4000/**. The server will auto-regenerate when you save changes to any source files.

## Deployment Workflow

1.  Any changes pushed to the `main` branch of this repository (`SnrBim.github.io`) will be automatically deployed to the live site by GitHub Pages.
2.  The content for the documentation is aggregated from the main `BIMTools` repository using the `Publish-Docs.ps1` script located there.

## Multilingual Setup (jekyll-multiple-languages-plugin)

This project uses the `kurtsson/jekyll-multiple-languages-plugin` to manage content in multiple languages (en, ru, es).

### Key Concepts:

*   **Language Files:** All translations for UI strings are stored in `.yml` files inside the `_i18n/` directory (e.g., `_i18n/en.yml`, `_i18n/ru.yml`).
*   **Page Content:** The content for pages is stored in language-specific subdirectories within `_i18n/`. For example, the content for the `docs/MyCommand.md` page is stored in `_i18n/en/docs/MyCommand.md`, `_i18n/ru/docs/MyCommand.md`, etc. These files should **not** contain any YAML front matter.
*   **Template Pages:** The main page files (e.g., `Docs/MyCommand.md`) act as templates. They contain the front matter (layout, title, permalink, etc.) and use the `{% translate_file path/to/content.md %}` tag to include the language-specific content from the `_i18n` directory.
*   **Linking Pages:** The `namespace` and `permalink` attributes in the front matter of the template page are used to link different language versions of the same page.

### Workflow for Adding a New Page:

1.  Create the language-specific content files (without front matter) in the `_i18n/` subdirectories (e.g., `_i18n/en/docs/NewPage.md`, `_i18n/ru/docs/NewPage.md`).
2.  Create a new template page in the main directory structure (e.g., `Docs/NewPage.md`).
3.  Add the front matter (layout, title, permalink, namespace) to the template page.
4.  Use the `{% translate_file docs/NewPage.md %}` tag in the template page to include the content.
