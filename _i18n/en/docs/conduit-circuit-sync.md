# Sync Conduit Circuit
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

This tool is designed to distribute electrical conduits into segments and record their paths in the electrical circuit parameters to complete the cable schedule.

## Required Data

Before running the command, ensure that at least one conduit in each segment has a circuit name in `SRS_MEP_Circuit_Names` and that a circuit with the same name exists. It is recommended to use the companion command **AssignConduitToCircuit** for this purpose.

## Algorithm Description

1.  **Parameter Unification:** Prepares equipment names in the `SRS_Schedule_Name` parameter by concatenating `SRS_Equipment_Type` and `SRS_Equipment_Number`. Instance-level overrides are supported (they take priority over Type), and redundant hyphens in the resulting name are removed automatically. The `SRS_Location` parameter is used as is from the elements.
2.  **Search:** Finds all conduits and circuits where the `SRS_MEP_Circuit_Names` parameter is defined.
3.  **Section Identification:** Detects groups of interconnected conduits (chains) based on physical connection and the shared value in `SRS_MEP_Circuit_Names`.
4.  **Grouping by Circuit:** Associates conduit chains with their respective electrical circuits.
5.  **Direction Determination:** Sorts the conduits in the path from the load to the electrical panel.
6.  **Segment Division:** The path is divided into segments between distribution boxes (a gap of up to 10 cm is allowed). The process stops with an error if there are more than 5 segments.
7.  **Segment Naming:** Each segment is assigned a name based on the panel and load locations. If the locations are different, both are specified (`Loc1-From/Loc2-To-Tag`); if they are the same, the prefix is written only once. The "CC" abbreviation has been removed from tags for brevity. The rules for forming the load name are as follows:

| Input Data | Resulting Load Name | Comment |
| :--- | :--- | :--- |
| `18D-DS-SF01` | `18D-DS-SF01` | A single name remains the same. |
| `18D-DS-SF01`, `18D-DS-SF02`, `18D-DS-SF03` | `18D-DS-SFxx` | Names with the same base are grouped with `xx` at the end. |
| `18D-DS-SF01`, `18D-DS-XY02` | `18D-DS-SF01, 18D-DS-XY02` | Heterogeneous names are listed separated by commas. |
| `"" (ID: 12345)`, `18D-DS-SF01` | `12345, 18D-DS-SF01` | If there is no name, the element's ID is used. |

8.  **Data Recording:**
    -   Updates `SRS_MEP_Circuit_Names` in all conduits of the segment.
    -   Fills in `SRS_MEP_Conduit_From`, `SRS_MEP_Conduit_To`, and `SRS_MEP_Conduit_Tag` in the conduits.
    -   The cable length is recorded in the `SRS_MEP_Cable_Length` parameter, including a safety reserve (+10% for lines up to 100 m and +5% for lines over 100 m), **rounded up to the nearest meter**.
    -   Stores segment names in the electrical circuit's `SRS_MEP_Conduit_Segment_1` to `SRS_MEP_Conduit_Segment_5` parameters.
9.  **Notification:** Confirms the operation and reports suspicious distances (>1m) between segments to detect potential assignment errors.

## Possible Errors

- **No conduits found:** If there are no conduits with the `SRS_MEP_Circuit_Names` parameter defined, the command will fail. Check that at least one conduit per segment has this parameter assigned (use **AssignConduitToCircuit**).
- **No electrical circuits found:** If no circuits with matching names in `SRS_MEP_Circuit_Names` exist, the command will fail. Ensure circuits exist and have correct names.
- **Too many segments:** If a path has more than 5 segments, the process stops with an error. Simplify the path or split the circuit.
- **Missing parameters:** If any required parameter (such as `SRS_Schedule_Name` on equipment) is missing or empty, it may cause errors. Changes are made in a transaction and can be undone with Ctrl+Z.

## Notifications and Statistics

After execution, a notification appears with:
- Number of circuits processed.
- Minimum and maximum cable length (in meters).
- Maximum gap between segments (in meters) and circuit ID.

If the gap exceeds 1 m, review conduit assignments, as it may indicate incorrect connections.

## Usage Tips

- Run the command in a floor plan view for best results.
- If circuit names change, manually update `SRS_MEP_Circuit_Names` on the conduits.
- The tool processes only conduits and circuits with the parameter defined; ignore other elements.
- The `SRS_Schedule_Name` parameter on equipment is updated automatically during each synchronization (concatenating type and number), so it does not need to be filled manually.

![image](https://github.com/user-attachments/assets/9a9058a0-1832-4f33-b80b-af01cc471fc6)

## Processing Options

- **Only selected conduits**: When enabled, the algorithm processes only those conduits you selected in Revit before launching. This is useful for precise synchronization of specific circuits.
- **Show result in specialized 3D view**: Creates or updates a special 3D view named `Conduit Review <user>` for a quick check of the result.
    - **Isolation and Section Box**: The tool automatically adjusts visibility and crops the view (Section Box) to the boundaries of the selected area.
    - **Clean View**: Helper elements (center lines, linked files) are hidden.

## Interface

- **Show this dialog (Shift/Ctrl to invert)**: Allows you to disable this window for instant tool launch with the last saved settings.
- **Inversion (XOR)**: If you want to bring up the window one time when the setting is off (or vice versa), hold **Shift** or **Ctrl** while clicking the button in Revit.

![UI](image.png)

## Changelog

2026-07-15
1. **Instance Parameter Priority**: `SRS_Equipment_Type` and `SRS_MEP_Tag_Type_Id` are now sought in the element parameters first, only falling back to Type if empty. This allows instance-level overrides.
2. **Name Cleaning**: Improved `SRS_Schedule_Name` assembly, eliminating trailing/leading hyphens when parameters are partially missing.

2026-07-13
1. **Diagnostic 3D View**: Automatic view creation for review with path isolation, hiding of center lines, and automatic section box.
2. **Selection Mode**: Added support for processing only manually selected conduits.
3. **Silent Launch**: Instant tool launch implemented with Shift/Ctrl hotkey support to call settings.

2026-07-09
1. Segment naming refined: if panel and load locations differ, both are specified (Loc1-From/Loc2-To-Tag); if they match, only one prefix is used (Loc-From/To-Tag).
2. Removed "CC" abbreviation from conduit tags (`SRS_MEP_Conduit_Tag`).
3. Implemented upward rounding of calculated cable length (`SRS_MEP_Cable_Length`) to the nearest meter (`Math.Ceiling`), while maintaining decimal precision in user reports for gap monitoring.
4. Implemented automatic location prefix selection (e.g., 16D, 18D) based on the `Functional_Breakdown_Code` parameter.

2026-06-19 Fixed error when `SRS_Schedule_Name` was missing on equipment or `SRS_Location` was empty (now defaults to '18D'). Parameter names moved to `%AppData%\Sener\BimTools\Settings.json`.

