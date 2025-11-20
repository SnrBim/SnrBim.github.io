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
    *   After selecting a link, the list below displays only those levels from that link where rooms containing fire alarm devices have been found.
    *   For each level, the UI now displays a separate count for **rooms with devices** and **empty rooms** in the format `Rooms: 7 + 10`. It also indicates the total number of **devices in rooms** and **homeless devices** (not assigned to any room).
    *   You can select one or more levels for processing by checking the boxes next to them.

### 3.1. Layout and Mapping Configuration

At the bottom of the window, there are two fields for fine-tuning the command's behavior:

*   **Sensor Definitions (Sensors):**
    *   This field determines which devices will be placed in the **top row** of the diagram (considered "sensors"). All other devices will be placed in the bottom row.
    *   Each line corresponds to one rule.
    *   **Format:** `FamilyName: TypeName`. The type name can be omitted, in which case all types of the specified family will be considered sensors. Matching is **case-insensitive**.

*   **Family Mapping:**
    *   This field defines the rules by which 3D device families and types are transformed into 2D symbols on the diagram.
    *   **Format:** `3D_Family: 3D_Type: 2D_Family: 2D_Type`.
    *   Each line represents a single rule. For example, the line `SRS_Smoke_Detector: Standard: Fire alarm 2d: Smoke detector` means that all 3D devices with family `SRS_Smoke_Detector` and type `Standard` will be represented on the diagram by the 2D symbol `Smoke detector` from the family `Fire alarm 2d`. Matching of 3D family and type names is **case-insensitive**.
    *   **Automatic Pre-population:** When the dialog opens, the command automatically scans the Revit model and identifies all unique `(3D_Family, 3D_Type)` combinations of fire alarm devices.
        *   Any newly discovered `(3D_Family, 3D_Type)` combinations that are not yet in the user's saved mapping settings are automatically appended to the list. For these new entries, the default values `Fire alarm 2d` and `Generic` are used for the 2D family and 2D type, respectively.
        *   Existing user settings, including comments and order, are always preserved.
    *   **Editing Features:** The field includes a built-in header demonstrating the string format and uses a monospaced font for convenience.
    *   **Comments:** Lines starting with a `;` character are ignored during parsing but are preserved and can be used for comments.
    *   **Alignment:** Text in this field is automatically aligned for better readability.

### 3.2. Additional Options

*   **Create empty rooms:**
    *   If this option is enabled (checked), the command will create 2D representations for *all* rooms on the selected levels, even if they do not contain any fire alarm devices.
    *   By default, this option is disabled, and 2D rooms are only created for 3D rooms that contain at least one device.

### 3.3. Manual Placement and Room Locking

After the initial diagram creation, you may want to manually adjust the layout of devices within certain rooms and lock their positions to prevent them from being reset during subsequent synchronizations.

This is achieved using the **"Manual placement"** instance parameter (a Yes/No type) on the 2D room family.

*   **How it works:**
    1.  Select one or more 2D rooms on the diagram.
    2.  In the Properties palette, find the **"Manual placement"** parameter and check the box (set its value to "Yes").

*   **What happens on the next sync:**
    *   **Device Positions are Preserved:** The command will no longer automatically arrange the existing 2D devices within this room. Their current positions will be locked.
    *   **Room Width is Preserved:** The width of this 2D room will also be locked and will not automatically change based on the number of devices.
    *   **New Devices:** If new devices are added to this room in the 3D model, their 2D symbols will appear **in the center** of the locked room. This allows you to easily find and manually place them where needed.

## 4. Step 2: Synchronization Process

After clicking the "OK" button, the process of creating and updating the 2D diagram on the active drafting view begins.

*   **Creating 2D Rooms:**
    *   For each room from the selected levels that contains at least one device, a 2D room (family "Room") is created on the diagram.
    *   If a 2D room for such a room already exists on the diagram, a new one is not created, but the existing one is updated.
    *   The **width of the room** is calculated automatically based on the maximum number of devices in one of the two rows to ensure they all fit. The minimum room width is 40 mm.
    *   The **Number**, **Name**, and **Level** from the source 3D room are written into the parameters of the 2D room.

*   **Creating 2D Devices:**
    *   Inside each 2D room, 2D device symbols are placed according to their 3D prototypes.
    *   **2D Symbol Selection:** The type of 2D symbol is determined based on the rules defined in the **"Family Mapping"** field. If no suitable rule is found for a 3D device, a default symbol ("Generic") is used, and the element is colored red.
    *   **Placement:** Devices are placed in **two rows** based on the rules from the **"Sensor Definitions"** field.
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
        *   The type of the 3D device has been changed, resulting in a different 2D symbol according to the mapping rules.

*   **Purple:**
    *   **Element moved.** If a 3D device was moved from one room to another, its 2D symbol on the diagram is also moved to the corresponding room and colored purple.

*   **Blue:**
    *   **Manually moved element.** If a 2D device was manually dragged from one 2D room to another on the diagram by the user, its 2D symbol will be colored blue. This indicates a user-initiated change in the diagram layout that is preserved across synchronizations.

*   **Red:**
    *   **"Orphaned" element or error.** An element is colored red if:
        *   The original 3D element (room or device) was deleted from the model.
        *   No mapping rule was found for the 3D device, and the default 2D symbol was used.

## 6. Change Tracking ("Sync info" Parameter)

Each 2D element on the diagram (both room and device) has a text parameter **"Sync info"**. It automatically records the history of all changes that have occurred during synchronization, with the date and time.

*Example record: "Moved from '101 - Office' to '102 - Corridor' [2025-10-28 14:30:15]"*

![image](.\pic2.png)
![image](.\pic3.png)

## 7. Known Limitations

*   **Level assignment for "homeless" devices:** Devices not belonging to any room ("homeless") are assigned to the nearest level below from a list of **"valid levels"** (i.e., those that contain rooms with devices). This is done to ensure that only relevant levels are displayed in the level selection list.
*   **Room Detection:** Room detection is performed with an additional check 200 mm above and 1000 mm below. In rare cases, if devices in the 3D model are located very close to the floor and outside a room, the algorithm may incorrectly assign the device to a room on the floor below.
*   **Automatic Room Width Adjustment:** When the number of devices in a room changes, its width on the diagram will be automatically adjusted. This behavior can be disabled for a specific room by using the "Manual placement" parameter (see section 3.3).
*   **No Automatic Shifting:** The script **does not shift** adjacent rooms if one of them has expanded. This is done to preserve the manual layout of elements on the diagram. If one room starts to overlap another, you will need to manually select and move the adjacent elements.

