# HVAC Schematic Data Synchronization (Sync Air Flow)
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

This command provides comprehensive data synchronization between the 3D model and 2D schematics, updating space names, air flow rates, and creating equipment annotations.

---

### Workflow
The tool is divided into independent steps that the user can select in the interface:

![Settings Window](ui.png)

1.  **Assign Spaces (Element Linking):** Links 3D equipment in the model with 3D spaces, filling the equipment parameter. This is required for the correct operation of all subsequent steps. (Duplication of the `AssignSpacesToEquipment` command, performed in a separate transaction).
2.  **Sync Room Names:** Copies the name from the 3D space to the space annotation parameter on the schematic.
    *   *Option:* **Name Shortener** — allows automatically shortening long names (e.g., "ELECTRICAL ROOM" → "ELEC. RM") based on rules from a schedule in the project.
3.  **Sync Unit Heaters:** Synchronizes the number of heating units. Counts 3D equipment in the space and creates/verifies the corresponding number of annotations on the schematic.
4.  **Sync Air Flow:** Sums the flow rates of all 3D diffusers by system type (supply/return) linked to the space, and records the total values, quantity, and system types in the schematic annotations.

### Key Features

#### 1. Name Shortener
A flexible abbreviation system managed by the user through a standard Revit schedule (`ViewSchedule`):
*   **Source of rules:** Schedule named "Space labeling config" (configurable).
*   **Format:** Two columns in the header — `Pattern` and `Replacement`.
*   **Wildcards:** Support for the `*` symbol (any number of characters). For example, the rule `*ELECTRICAL* → ELEC.` will replace any variation with this word.
*   **Cleanup:** Automatic removal of extra spaces after replacements.

![Config Table](nameShortener.png)

#### 2. Intelligent View Management
*   **Filter by View:** Ability to run processing only for the active view or for the entire project (all schematics).

#### 3. Data Safety
*   The tool never automatically deletes unit heater annotations. If there are more annotations than equipment, they are marked as "extra" in the final report for manual review.

#### 4. Results

*   3D equipment will be filled with the **SRS_MEP_Room_Space_Mark** parameter in the format RoomName-RoomNumber.
*   The **Room Name** parameter in space annotations will be updated.
*   In diffuser annotations (`SRS_Hvc_Generic_Annotations_Diffuser 2D`), the following parameters will be updated:
    *   **Total flow rate:** Total air flow from all matched 3D terminals.
    *   **Number of units:** Total number of matched 3D terminals.
    *   **Mass flow rate:** Average air flow (total flow / quantity).
    *   **Flow Details:** A text string with calculation details (e.g., `2 × 150L/s + 1 × NoParam`).
*   Missing 2D annotations for unit heaters will be created. New annotations are placed in a column, starting from the bottom-left corner of the room on the schematic.

![schematic example](scheme.png)

### 5. Interactive Report

The command provides a detailed report of the actions performed.

*   **Short Report:** A summarized version is displayed in the main window. Long lists of errors (more than 10-20) are automatically truncated for readability.
*   **Full Report:** To view the complete list of all messages and IDs, click the **Open full report** button. This will create a text file with the full report and open it in your default editor.

### 6. Limitations and Operation Logic

*   **Extra Annotations:** The command **does not delete** "extra" unit heater annotations. Instead, it reports them.
*   **System Matching Logic (for Air Flow):**
    1.  The **System Class** (`Supply Air` or `Return Air`) is determined by the **type** name of the 2D diffuser annotation (`Supply` or `Exhaust`).
    2.  First, the command matches 2D annotations with 3D terminals by **exact match** of the space and the calculated system class.
    3.  **If multiple systems of the same class are found in one space**, more complex logic is used:
    4.  The name of the view where the 2D annotation is placed is searched as **part of the name** of the duct system in 3D.
        *   *Example: 2D annotation on view `HVAC Plan SA-1` will be matched with system `SA-1-Office`.*
    5.  If matching by view name fails, the command will perform an **arbitrary** match and report it in the report.

### 7. Configuration via JSON

Some operation parameters, such as **family and parameter names**, can be configured through the central BIM Tools configuration file. This allows adapting the command to your project standards without changing the code.

The settings file is located at:
`%AppData%\Sener\BimTools\Settings.json`

> **How to open this path?**
> `%AppData%` is a standard Windows shortcut for accessing a hidden folder with settings.
>
> 1.  Copy the full path (including `%AppData%`, but without the file name: `%AppData%\Sener\BimTools`).
> 2.  Open Windows Explorer (any folder, e.g., "My Computer").
> 3.  Click on the address bar, paste the copied path, and press Enter. The folder with the `Settings.json` file will open directly.

For this command, find the `SyncAirFlowSettings` section in the file, change the necessary values, and save the file. No Revit restart is required; just run the command.

> **Note for `UnitHeater3d`:**
> In the current version, for the list of 3D unit heaters (`UnitHeater3d`), **only the family name** is considered. Everything specified after the colon (`:`) will be ignored. The tool will automatically process all types for each specified family.

## Work Log
2026.06.11 UI added with step division and Name Shortener. Fixed unit heater duplication bug when multiple schematics have the same space.

