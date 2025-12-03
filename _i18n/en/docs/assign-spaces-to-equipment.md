# Assign spaces to equipment
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

## Brief Description

The `Assign spaces to equipment` tool automatically assigns MEP space information to mechanical equipment, duct accessories, and duct terminals based on the MEP space they are located in. It finds the containing space for each element and writes the name and number of that space to an equipment parameter.

## How it works

1.  **Element Collection**: The tool finds all families in the model from the following categories:
    *   `Mechanical Equipment`
    *   `Duct Accessories`
    *   `Duct Terminals`
    *   `MEP Spaces`

2.  **Search and Linking**: For each element from the tracked categories, the tool determines its insertion point and searches for the MEP space that contains this point.

3.  **Data Writing**: If a space is found, the tool forms a text string in the format **"`<Space Name>-<Space Number>`"** and writes this value to the equipment's parameter (the name of which can be configured, see "Parameter Name Configuration" section). By default, this is **`SRS_MEP_Room_Space_Mark`**.

    *For example, if the space has the Name "Office" and Number "101", the value "Office-101" will be written to the parameter.*

4.  **Report**: Upon completion, the tool displays a report indicating:
    *   The total number of elements found.
    *   The number of elements whose parameters were updated.
    *   The number of elements whose data was already up-to-date.
    *   The number of successfully linked elements.
    *   A list of errors and warnings if any elements could not be processed (e.g., if an element is not located in any space or if it lacks the necessary parameter).

## Parameter Name Configuration

The parameter name where room information is written is `SRS_MEP_Room_Space_Mark` by default. You can change this name by editing the command's settings file.

1.  **Locate the settings file**: The `Settings.json` file is located at the following path:
    `%APPDATA%\Sener\BimTools\Settings.json`

2.  **Open the file**: Open `Settings.json` with any text editor (e.g., Notepad).

3.  **Change the value**: Inside the file, find the section related to the `AssignSpacesToEquipment` command and change the value of the `EquipmentSpaceParameter` to your desired name.

    Example:
    ```json
    {
      "SNR.BimTools.AssignSpacesToEquipment.Settings": {
        "EquipmentSpaceParameter": "My_Room_Parameter"
      }
    }
    ```
    Ensure that the new parameter name exactly matches the parameter name in your Revit project.

4.  **Save the file**: Save the changes to `Settings.json`. The command will use the new parameter name the next time it runs, **no Revit restart is required**.

## Requirements

*   For correct operation, the tracked elements must have a text parameter with the name specified in the command's settings (by default, this is **`SRS_MEP_Room_Space_Mark`**).
*   The model must contain correctly modeled `MEP Spaces`.

## Usage

1.  Navigate to the **SENER** tab.
2.  In the **BIM Tools** panel, click the **"Assign spaces to equipment"** button.
3.  Wait for the window with the operation report to appear.

The tool does not require prior selection of elements and processes all eligible elements in the project.
