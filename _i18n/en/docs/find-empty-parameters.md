# Find empty parameters
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

The **Find empty parameters** command checks whether the specified parameters are filled in the current Revit model and loaded links, then generates a summary Excel report.

## What the command does

- Processes the current model and available loaded links.
- Checks only the selected Revit categories.
- Checks parameters for both instances and their types.
- Considers an instance problematic if at least one checked parameter is empty.
- Produces a summary report with grouped information by category, family, and type, without a separate description of every element.
- Shows the processing progress and allows you to cancel the check.

## Usage

Enter the names of the parameters to check in the **Parameters to check** field, one per line, and click **OK** or press `Enter`.

Empty lines are removed, and duplicate names are merged case-insensitively. The parameter list is saved for the next run.

To close the window without starting the check, click **Cancel** or press `Esc`.

![User interface](ui1.png)

The **Categories (X/Y)** button opens the list of categories to check. `X` is the number of recognized categories, and `Y` is the total number of entered categories. Unknown categories are skipped during the check. Their names are shown after clicking **OK** in the category window.

![Categories](ui2.png)

## Checking rules

A parameter is considered empty if it is missing, has no value, or contains only whitespace.

Parameters of elements and their types are checked. An element is considered problematic if at least one checked parameter is empty.

The `IsByType` column indicates the source of the empty value:

- `0` means that the empty parameter was found on the instance;
- `1` means that the empty parameter was found on the type;
- an empty value means that empty parameters were found on both sources for one instance.

## Excel report

The Excel file is created in the standard BIMTools reports folder: `%appdata%\Sener\BimTools\Reports\EmptyParams\`.

The report contains an `Empty parameters` sheet with summary information:

| Column | Contents |
| --- | --- |
| `Model` | Short model name without the `.rvt` extension |
| `Category` | Element category |
| `Total` | Total number of instances in the category |
| `Problematic` | Number of problematic instances |
| `IsByType` | Source of the empty value: `0`, `1`, or empty |
| `Family` | Family and type of the problematic elements |
| `Instance ID` | IDs of the problematic instances |

## Processing and cancellation

If the check is cancelled, the data processed so far is saved in a partial report.

## Result

After the report is created, the result window allows you to open the report or copy its path to the clipboard. It also shows:

- the number of processed files and the total number of files;
- the number of categories with problems;
- the number of problematic elements for each model.

