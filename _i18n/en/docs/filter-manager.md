# Filter Manager
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

This command manages project filters and their graphic overrides on views through Excel.

## Export

1. Select the required views in the Project Browser. If no suitable views are selected, the command uses the active view.
2. Run **Create filters**.
3. When the window opens, all filters on the selected views are checked, except complex nested filters. If the views contain no available filters, all available project filters are checked.
4. Click **Export to Excel** and save the file.

> Use the checkboxes to control which filters are exported to the `Doc filters` sheet. View filters are exported independently of the checkboxes.

The bottom of the window shows the number of views selected before running the command, their overrides and filters in use, and the number of checked project filters.

![Command window and export summary](ui.png)

## Excel sheets

The export creates a workbook with two sheets:
- `Doc filters` — project filter names, categories and rules.
- `View filter overrides` — filters on views, their visibility and graphic settings.

If a selected view has no filters, a row with its ID and name is still created so that you can fill it in later.

## Editing and creating filters

### Edit a project filter

On the `Doc filters` sheet, edit the name, categories or rules **without changing the ID**. Unlike creating a new filter, editing a filter requires confirmation during import. This helps prevent accidental updates if the model and an older export no longer match.

Numeric rule values are exported in document units and converted back during import.

![Project filters in Excel](filterExcel.png)

![Filter rules in Revit](filterRevit.png)

### Create a filter

1. On the `Doc filters` sheet, copy a suitable row.
2. Clear its ID and enter a name and rules.
3. To assign the filter to a view, add a row on the `View filter overrides` sheet: enter the view ID and filter name, and leave the filter ID empty.

Names on the `Doc filters` sheet must be unique. If a new name already exists in the project, the command offers one choice for all conflicts: update the existing filters, create new ones with incremented suffixes, or cancel the import. If new names are chosen, the corresponding view rows with empty filter IDs are linked to the new filters.

### Edit settings on a view

On the `View filter overrides` sheet, edit visibility, colors, patterns, line weights or other settings.

- Enter colors as `R,G,B`, for example `255,0,0`. The cell background is for reference only and is not imported.
- Enter patterns by name.
- An empty color or pattern cell resets the corresponding override.
- Enter Boolean values (yes/no) as `1` or `0`; empty cells use Revit's default values.

![Filter overrides in Excel](overrideExcel.png)

![Filter overrides on a view in Revit](overrideRevit.png)

## Import

Click **Import** and select the edited file. After import, a window shows the number of changed views and overrides, and created and updated filters.

**Limitations:**

- Deleting filters from the project or from views is not supported; deleting Excel rows does not remove filters in Revit.
- The command does not change the order of filters already assigned to a view. Changing the row order or the `Filter Order` column in Excel does not affect their order in Revit.
- Complex filter definitions, including OR and filters with more than three rules, are skipped during import. Their graphic settings on views can still be managed.
- If the units of a numeric parameter cannot be determined, for example because there are no elements with that parameter, the value is exported in Revit internal units and an informational note is added to the cell. During import, the value is also treated as internal if the units cannot be determined.

## Change history

2026-11-02 Added view filter management.

2026-07-08 Initial implementation (project filter management).

