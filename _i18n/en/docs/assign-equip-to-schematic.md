# Assign Equipment to Schematic
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

## General Description

This command allows you to automatically associate an MEP equipment (family) with one or more schematic diagrams (generic annotations) within the Revit model. It is designed to facilitate system documentation and tracking by linking real model elements to their schematic representations.

![image](.\pic1.png)

## Core Functionality

When the command is executed with an equipment and a schematic selected, it updates the following parameters in the schematic's annotation:

-   **`SRS_MEP_Equipment_Id`**: Contains the ID, type, and name of the equipment.
    -   *Example: `123456 FamilyType: EquipmentName`*

-   **`SRS_MEP_Link_Id`**: Indicates the origin of the equipment.
    -   If it comes from a linked model, its name is displayed.
    -   If it belongs to the current model, it is indicated as "current model".

## Status Visualization Mode

If you run the command **without selecting any elements**, a graphical visualization mode is activated in the current view. This mode creates status circles over visible equipment to indicate if they are linked to a 2D schematic:

-   **Red Circle**: The equipment is not linked to a 2D schematic.
-   **Green Circle**: The equipment is already linked to a 2D schematic.

Running the command again with no selection will remove the status circles (it acts as a toggle).

## How to Use

### Standard Assignment
1.  Select a single piece of equipment (family) from the active model.
2.  Select one or more annotations belonging to the `Generic Annotation` category.
3.  Run the **Assign Equipment to Schematic** command.
4.  A notification will confirm the assignment.

### Assignment from Linked Files
You do not need to select the equipment directly inside the linked file.
1.  Activate the **Status Visualization Mode** to see the colored circles.
2.  Select the **status circle** (red or green) over the equipment you want to link.
3.  Select the corresponding 2D schematic symbol.
4.  Run the command. The algorithm will automatically detect the correct link between the two elements.

## Requirements and Validations

-   For assignment, only **one** piece of equipment (or its status circle) must be selected. If more than one is selected, the command will show an error and stop.
-   The annotations must be of the **Generic Annotations** category.

