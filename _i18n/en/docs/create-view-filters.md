# Create View Filters
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

This tool allows for the batch creation and modification of view filters using Excel.

### What the Command Does
*   Exports existing filters to an Excel table.
*   Enables batch editing of names, categories, and filtering rules in the table.
*   Creates new filters if the **Id** column is empty.

### Preparation
*   There should be at least basic filters created in the project for an export example.
*   Use exact values from Revit for naming parameters and categories (it's best to take them from the initial export).

![ui](image.png)

### Usage
1.  Click the **Create filters** button.
2.  Sort by name or by newest via the right-click context menu.
3.  In the opened window, select the desired filters (use search or the active view filter, group selection with Shift/Ctrl).
4.  Click **Export Selected** and save the file.
5.  Edit the Excel file:
    *   Change names in the **Name** column.
    *   Edit categories and rules (up to 3 per filter).
    *   To create a filter copy, copy the row and clear the **Id** column.
6.  Return to Revit, click **Import from File...** and select the modified file.

![excel](image-1.png)

### Results
*   **New filters**: created in the project with settings from Excel.
*   **Existing filters**: updated only in case of actual data changes (the algorithm skips unchanged rows).
*   **Report**: upon completion, you will see a notification with the number of created and modified elements.

### Features
*   Complex nested filters are not yet supported (contact the developer if necessary).
*   Parameter format: in Excel, parameters are stored in the format `ID | Name | Type` — this is necessary for precise identification. The export relies on the ID; the parameter name is displayed only for user convenience.
*   If a filter name already exists in the project when creating a new one, the import will result in an error to avoid duplicates.

