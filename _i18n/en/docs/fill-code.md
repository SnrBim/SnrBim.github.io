# FillCode Command
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

## Purpose

<img src="Logo.png" alt="Logo" style="float:right; margin:0 15px 15px 0;" width="48"/> The **FillCode** command is designed to automatically generate and assign a unique identification code to elements in a Revit model. The code is created based on a set of rules that can be configured using an external Excel file and is written to the element's `IDD_PDS_CODE` parameter.

This allows for the standardization of element identification according to project requirements.

## How to Use

When the command is launched, a settings window opens, allowing you to control the code generation process.

![FillCode UI](image.png)

### 1. Mapping Configuration

The command's behavior is entirely determined by mapping rules. You have two options:

*   **Use Default Values:** If the "Path to Excel file" field is empty, the command will use an internal, hard-coded set of rules.
*   **Use an External Excel File:** You can specify the path to an Excel file with your own rules. This provides maximum flexibility.

#### Managing the Mapping File:

*   **"Path to Excel file" field:** Enter the path to your `.xlsx` file here. The path is saved between Revit sessions.
*   **"Browse..." button:** Opens a dialog to select the file.
*   **"Export Default Settings" button:** Creates a template Excel file with the standard rules. You can use this as a starting point for your own mappings.
*   **"Reload" button:** Allows you to manually refresh the summary information after making changes to the Excel file.

### 2. Filters and Options

*   **"Ignore 'Generic Models' category":** Enabled by default. This excludes elements of this category from processing, as they are often auxiliary.
*   **"Debug mode":** If this checkbox is selected, the command will execute all logic, analyze the elements, and generate a detailed report, **but will not make any changes to the model**. This is a safe way to verify the correctness of the settings before actually applying the codes.

### 3. Summary Panel

This read-only text field displays summary information about how the command will operate with the current settings.

*   **Data Source:** Shows whether "Default Values" or the specified Excel file is being used.
*   **Launch Parameters:** Displays key identifiers extracted from the current Revit file's name (Work Package, Building Code), which are used to find the correct rules.
*   **Mapping Summary:** Shows how many rules have been loaded (number of categories, disciplines, location codes, levels for the current work package).
*   **Element Count:** Shows how many elements in the current view or selection will be processed.

### 4. Execution and Reporting

After clicking the **"OK"** button, the command processes the elements and displays a final message with the number of successful operations, warnings, and errors.

You will be prompted to open a **detailed text report**, which contains:

1.  **Summary:** Full information about the launch parameters and loaded rules.
2.  **Problematic Elements:** A list of elements that could not be processed, with the reason (e.g., "sublocation code not found," "level not determined").
3.  **Successfully Processed Elements:** A table of all elements for which the code was successfully generated. The data is presented in a format ready for copying into Excel and is sorted by category.

## Generated Code Structure

The final code has the following format:

`DisciplineCode-CategoryCode-LocationCode-SubLocationCode-LevelCode`

*   **DisciplineCode:** The discipline code (e.g., "H" for HVAC, "E" for Electrical), determined by the element's category.
*   **CategoryCode:** The element's category code (e.g., "DCT" for ducts).
*   **LocationCode:** The location code, determined by the building code from the file name.
*   **SubLocationCode:** The sub-location code, read from the instance parameter `IDD_SUBLOCATION`. If the parameter is empty, `?` is used.
*   **LevelCode:** The level code, determined based on the element's Z-coordinate and the "Work Package" from the file name.

## Excel File Structure

The mapping file can contain several sheets to configure different rules:

*   **CategoryDiscipline:** A matrix for mapping Revit categories to discipline codes (`DisciplineCode`) and category codes (`CategoryCode`).
*   **Location:** A table for mapping "building codes" (from the file name) to `LocationCode`.
*   **Levels:** A sheet for mapping Z-coordinates to level codes (`LevelCode`). The data on this sheet is organized into blocks of two columns, where each block has a two-row header:
    1.  **Row 1:** Contains the **mapping key**. This can be a "Work Package" (e.g., `CNT3`) or a composite key `"{Work Package} {Building Code}"` (e.g., `CNT7 E110`).
    2.  **Row 2:** Contains the data headers: `Min Z` for the minimum level elevation (in meters) and `Code` for the level code.

![Matrix Table](image-1.png)
