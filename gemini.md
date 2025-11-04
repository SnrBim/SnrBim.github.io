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
