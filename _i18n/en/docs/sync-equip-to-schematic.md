# Sync Equipment to Schematic
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

This command automatically updates the data of schematic annotations (Generic Annotation) in Revit, based on the previously assigned equipment ID.

![image](.\pic1.png)

## Functionality

For each processed schematic annotation, the command performs the following actions:

1.  It searches for the corresponding equipment using the values in the `SRS_MEP_Equipment_Id` and `SRS_MEP_Link_Id` parameters.
2.  Once the equipment is found, it determines the MEP Space and the Level where the equipment is located.
3.  It updates the following parameters in the annotation:
    -   **`SRS_MEP_Location`**: Updated with the space's name.
    -   **`SRS_MEP_RoomID`**: Updated with the space's ID.
    -   **`SRS_MEP_Level`**: Updated with the level's name.

## How to Use

1.  Ensure that the schematic annotations you want to update already have values assigned to the `SRS_MEP_Equipment_Id` and `SRS_MEP_Link_Id` parameters.
2.  Run the **Sync equip to schematic** command.
3.  The system will process the annotations and automatically update the location data in each one.

## Important Notes

-   A warning will be displayed if the equipment corresponding to the ID specified in an annotation is not found.
-   The equipment ID value must be numeric for the process to work correctly.
-   The space search is optimized; the command prioritizes reusing already found spaces to improve performance.

