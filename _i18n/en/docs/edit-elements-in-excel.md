# Editing Parameters in Excel
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

## Description

This command allows you to export selected parameters of Revit elements to an Excel file for easy editing, and then import the modified data back into the Revit model. It supports the use of Excel formulas and can update or add data to previously created files.

## Additional Features

-   **Custom Columns in Excel**: You can add new columns (parameters) directly in the Excel file. When using the "Update file..." function, the command automatically recognizes these new columns and fills them with data, eliminating the need to select parameters in the interface every time you run it.

-   **Preservation of Formulas and Column Order**: If you use Excel formulas in cells, they will be preserved when the file is updated (such cells are marked in green). The column order is also preserved, allowing you to customize the table view to your needs.

-   **Edit in TXT Mode**: For simple edits, you can use the "Edit as txt file" option from the additional options menu (⋮). The data is exported to a text file where each value is on a new line.

-   **Special Parameters (nonParams)**: The command allows you to export not only standard Revit parameters but also special, calculated values. They have a `_` prefix (e.g., `_Coordinates`, `_HostId`, `_SpaceName`, `_RoomNumber`). These parameters are read-only.

## Usage

1.  Run the "Edit in Excel" command from the BIMTools tab in Revit.
2.  In the window that appears, select the element parameters you want to export/edit.
3.  Use the options to include type parameters, instance parameters, alphabetical sorting, or include a sheet with project information.
4.  Click "Edit in Excel" to export and start editing.
    *   The command will create an Excel file with Revit elements as rows and the selected parameters as columns.
    *   After finishing editing in Excel, confirm in Revit to import the changes.
    *   **Note:** When you use the "Edit in Excel" option to export data and wait for editing, the created Excel file is saved by default to the folder: `%appdata%\Roaming\Sener\BimTools\Reports\EditInExcel\<Revit_Model_Name>\`, with a name that includes the current date and time.
5.  Use "Write to file..." to save the Excel file without waiting for import.
6.  Use "Update file..." to add new elements or update existing ones in an already created Excel file.
7.  Use "Read from file..." to import data from a previously saved Excel file.

![alt text](image.png)

## Use Cases

### 1. Renumbering Sheets or Rooms

-   **Task**: You have a large set of sheets (e.g., 100+), and you need to quickly change their numbering by adding a prefix (e.g., `A-101` -> `AR-101`). Doing this manually in Revit is slow and inconvenient.
-   **Solution**:
    1.  Select all sheets in the Project Browser.
    2.  Run the "Edit in Excel" command and export the "Sheet Number" parameter.
    3.  In the resulting Excel file, use formulas to bulk-change the numbers. For example, in an adjacent cell, write `="AR-" & MID(A2,3,100)`, copy the formula for all rows, and then copy the result as values back into the "Sheet Number" column.
    4.  Save the file and import the changes back into Revit. All sheets will be instantly renumbered.

### 2. Copying Wall Lengths to the "Comments" Parameter

-   **Task**: To create an external schedule or report, you need the length of each wall to be written to its "Comments" parameter.
-   **Solution**:
    1.  Select all the desired walls.
    2.  Run the command and export the "Length" and "Comments" parameters.
    3.  In the Excel file, you will get two columns. In the "Comments" column, enter a simple formula that references the cell with the length (e.g., `=C2`), and extend it to all rows.
    4.  You can also add text, for example, `="Wall length: " & C2 & " mm"`.
    5.  Save the file and import the changes. The "Comments" parameter for all walls will be filled with their length values.

### 3. Bulk Updating Data from an External File

-   **Task**: An engineer or designer has sent you an Excel spreadsheet with updated data for rooms (e.g., new names, floor finish, ceiling finish). Entering these changes manually is time-consuming and prone to errors.
-   **Solution**:
    1.  Select all rooms in the Revit model.
    2.  Export the parameters to be updated (e.g., "Number", "Name", "Floor Finish"), as well as `ElementId`, to Excel.
    3.  Use the `ElementId` or room "Number" as a unique key to link with the external file. Use the `VLOOKUP` function in Excel to transfer the updated data from the engineer's file to your working spreadsheet.
    4.  Save the file and import. All room data in the Revit model will be updated according to the spreadsheet.
