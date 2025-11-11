# User Guide for the "Sync Fire Alarm Diagram" Command
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

## 1. Purpose of the Command

The command is designed for the automatic creation and subsequent synchronization of a 2D layout diagram of fire alarm devices based on a 3D model. It generates 2D elements on a drafting view corresponding to rooms and devices and tracks changes in the model to update the diagram.

![image](.\pic1.png)

## 2. Preparation

1.  **Architectural Model:** A linked model (Revit Link) with architectural rooms (`Rooms`) must be loaded into the project.
2.  **Active View:** Before running the command, you must open a **drafting view** where the diagram will be placed.

## 3. Step 1: Selecting Source Data

When the command is launched, a dialog box opens where you need to specify the source data for synchronization.

*   **Architectural Link:**
    *   The dropdown list shows all linked Revit files where rooms have been found.
    *   The list is automatically sorted: priority is given to links with "AR" in their name, and then by the descending number of rooms. As a rule, the required link is already selected by default.

*   **Levels for Synchronization:**
    *   After selecting a link, the list below displays all levels from that link where fire alarm devices have been found.
    *   For each level, the total number of rooms and the devices within them is indicated.
    *   You can select one or more levels for processing by checking the boxes next to them.

## 4. Step 2: Synchronization Process

After clicking the "OK" button, the process of creating and updating the 2D diagram on the active drafting view begins.

*   **Creating 2D Rooms:**
    *   For each room from the selected levels that contains at least one device, a 2D room (family "Room") is created on the diagram.
    *   If a 2D room for such a room already exists on the diagram, a new one is not created, but the existing one is updated.
    *   The **width of the room** is calculated automatically based on the maximum number of devices in one of the two rows (see below) to ensure they all fit. The minimum room width is 40 mm.
    *   The **Number**, **Name**, and **Level** from the source 3D room are written into the parameters of the 2D room.

*   **Creating 2D Devices:**
    *   Inside each 2D room, 2D device symbols (family "Fire alarm 2d") are placed according to their 3D prototypes.
    *   **Placement:** Devices are placed in **two rows**:
        1.  **Top row (sensors):** `Pull Station`, `Heat detector`, `Smoke detector`.
        2.  **Bottom row (notification appliances and manual call points):** `Strobe`, `Horn strobe`, `Horn`.
    *   The following are written into the parameters of the 2D device:
        *   `Code`: Copied from the `Mark` parameter of the 3D device.
        *   `Room`: Room number and name.
        *   `RoomLevel`: Name of the room's level.

## 5. Result and Color Indication

After synchronization, the elements on the diagram are colored differently depending on their status. This allows for a quick assessment of what changes have occurred in the model.

*   **Black (standard color):**
    *   A new 2D room and all devices in it, created for the first time.

*   **Green:**
    *   A new 2D device that was added to an existing 2D room on the diagram.

*   **Orange:**
    *   **Data updated.** An element is colored this way if:
        *   The room's number or name has changed.
        *   The type of the 3D device has been changed (e.g., `Smoke detector` replaced with `Heat detector`).

*   **Purple:**
    *   **Element moved.** If a 3D device was moved from one room to another, its 2D symbol on the diagram is also moved to the corresponding room and colored purple.

*   **Red:**
    *   **"Orphaned" element.** If the original 3D element (room or device) was deleted from the model, its 2D representation on the diagram remains but is colored red. This signals that the element on the diagram is no longer linked to the model.

## 6. Change Tracking ("Sync info" Parameter)

Each 2D element on the diagram (both room and device) has a text parameter **"Sync info"**. It automatically records the history of all changes that have occurred during synchronization, with the date and time.

*Example record: "Moved from '101 - Office' to '102 - Corridor' [2025-10-28 14:30:15]"*

![image](.\pic2.png)

## 7. Known Limitations

*   **Room Detection:** Room detection is performed with an additional check 200 mm above and 1000 mm below. In rare cases, if devices in the 3D model are located very close to the floor and outside a room, the algorithm may incorrectly assign the device to a room on the floor below.
*   **Automatic Room Width Adjustment:** When the number of devices in a room changes, its width on the diagram will be automatically adjusted during the next synchronization.
*   **No Automatic Shifting:** The script **does not shift** adjacent rooms if one of them has expanded. This is done to preserve the manual layout of elements on the diagram. If one room starts to overlap another, you will need to manually select and move the adjacent elements.

