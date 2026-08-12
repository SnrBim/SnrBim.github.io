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
3.  **Section Identification:** Detects groups of interconnected conduits (chains) based on physical connection. The tool automatically recognizes parallel branches within a segment using the `SRS_MEP_Parallel_Id` parameter.
4.  **Grouping by Circuit:** Associates conduit chains with their respective electrical circuits. It validates the uniqueness of circuit names across the entire project to prevent duplicates on mounting schemes.
5.  **Direction Determination:** Sorts route components from load to panel, consistently handling parallel branches.
6.  **Segment Division:** The route is divided into logical segments between distribution boxes.
7.  **Segment Naming:** Each segment is assigned a name based on the panel and load locations. For parallel chains within a single segment, unique suffixes are generated for each branch (e.g., `-PS01`, `-PS02`). The rules for forming the load name are as follows:

| Input Data | Resulting Load Name | Comment |
| :--- | :--- | :--- |
| `18D-DS-SF01` | `18D-DS-SF01` | A single name remains the same. |
| `18D-DS-SF01`, `18D-DS-SF02`, `18D-DS-SF03` | `18D-DS-SFxx` | Names with the same base are grouped with `xx` at the end. |
| `18D-DS-SF01`, `18D-DS-XY02` | `18D-DS-SF01, 18D-DS-XY02` | Heterogeneous names are listed separated by commas. |
| `"" (ID: 12345)`, `18D-DS-SF01` | `12345, 18D-DS-SF01` | If there is no name, the element's ID is used. |

8.  **Data Recording:**
    -   Updates `SRS_MEP_Circuit_Names` in all conduits of the segment.
    -   Fills in `SRS_MEP_Conduit_From`, `SRS_MEP_Conduit_To`, and `SRS_MEP_Conduit_Tag` in the conduits. The panel and load locations are added to `From` and `To`, respectively.
    -   Groups conduit and fitting lengths within each segment by the `RGS`, `PVC`, and `FIBERGLASS` codes in the type name. Each group is rounded up to the nearest meter, preserving the maximum-length rule for parallel branches, and written to `SRS_MEP_Length` for the elements in that group. Types without a recognized code form a separate group with their own total length.
    -   The cable length is recorded in the `SRS_MEP_Cable_Length` parameter, which is calculated according to the following algorithm:
        1.  **Conduits and Fittings**: the sum of lengths for all elements. For elbows, the distance between connectors multiplied by a coefficient (**1.15** for angles >45° and **1.05** for angles ≤45°) is used for family parameter independence.
        2.  **Equipment Gaps**: rectilinear distances from the panel's virtual target point to the first conduit and from the last conduit to the nearest load's virtual target point are added. The target point does not coincide with the equipment insertion point; it is located at the equipment's opposite vertical edge relative to the conduit endpoint.
            - The equipment's vertical boundaries are determined relative to the insertion point using `Default Elevation` (`DE`) and `SRS_Height` (`H`).
            - If `DE > 0`, the lower boundary is `DE - H` and the upper boundary is `DE`.
            - If `DE <= 0`, the lower boundary is `0` and the upper boundary is `H`.
            - `Default Elevation` is read from the equipment type. `SRS_Height` is read from the instance first and, if the parameter is absent, from the type.
            - If the conduit endpoint is above the equipment's upper boundary, the lower boundary is used as the target. If the conduit endpoint is below the lower boundary, the upper boundary is used.
            - If the conduit endpoint is between the boundaries, the edge with the greater vertical distance from the conduit endpoint is selected.
        3.  **Junction Boxes**: gaps at box locations where the run is broken are accounted for.
        4.  **Multi-device Circuits**: if there are multiple loads (e.g., lighting), the shortest path passing through all points ("snake") from the last box is calculated.
        5.  **Reserve**: a fixed safety reserve of **+2 meters** is added.
        6.  **Rounding**: the final value is rounded up to the nearest meter.
        - For parallel branches, the length of the **longest branch** is recorded for the circuit.
    -   Stores segment names in the electrical circuit's `SRS_MEP_Conduit_Segment_1` to `SRS_MEP_Conduit_Segment_5` parameters.
9.  **Notification:** Confirms the operation and reports suspicious distances (>1m) between segments to detect potential assignment errors.
10.  **Collision Check:** Validates unique identifiers (BaseCode) assigned to different electrical circuits. If overlaps are found, a summary report is provided upon completion.

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
    - **Isolation and Section Box**: The tool automatically adjusts the Section Box to the boundaries of the selected area.
    - **Optional Isolation**: Use "Isolate elements in 3D view" to hide everything except the route, panel, and loads. If disabled, elements are shown within the building context (transparent or wireframe depending on view settings).
    - **Clean View**: Helper elements (center lines, linked files) are hidden.
    - **Full System View**: The view automatically includes the electrical panel and all loads of the circuit.

## Interface

- **Show this dialog (Shift/Ctrl to invert)**: Allows you to disable this window for instant tool launch with the last saved settings.
- **Inversion (XOR)**: If you want to bring up the window one time when the setting is off (or vice versa), hold **Shift** or **Ctrl** while clicking the button in Revit.

![UI](image.png)

## Changelog

2026-08-12
1. **Locations in conduit parameters**: Added the panel and load locations to `SRS_MEP_Conduit_From` and `SRS_MEP_Conduit_To`, respectively, so schedules display the complete equipment identifiers.
2. **Material-specific length separation**: Conduit and fitting lengths within each segment are separated by the `RGS`, `PVC`, and `FIBERGLASS` codes, rounded up separately to the nearest meter, and written to `SRS_MEP_Length`. Types without a code are handled as a separate group.

2026-08-06
1. **Cable length calculation fix**: Fixed an error that caused the ends of conduit chains to be determined in reverse order in some cases. This resulted in incorrect terminal distance calculations.

2026-08-03
1. **Settings fix**: The setting to run Sync after Assign no longer affects standalone Sync. The 3D view and selected conduits settings now work independently.
2. **Terminal distance calculation to equipment boundaries**: Added calculation to a virtual equipment edge instead of the insertion point.
3. **Fixed cable reserve**: According to the new standards, the automatic cable reserve is now a fixed **+2 meters** per route instead of a percentage-based value.

2026-07-30
1. **Configurable 3D View Isolation**: Added "Isolate elements in 3D view" option.
2. **Enhanced Visualization**: The review view now automatically includes the panel and all loads.

2026-07-29
1. **Segment Length Recording in Conduits**: Implemented recording of the segment length into the `SRS_MEP_Length` parameter for each route element. The value is rounded up to the nearest meter.
2. **Reserve Logic Update**: Cable length reserve calculation changed from percentage-based (5-10%) to a fixed value (+2 meters to the total route length).

2026-07-23
1. **Parallel Circuit Support**: Implemented the ability to link a single electrical circuit to multiple physically parallel conduit chains (using the `SRS_MEP_Parallel_Id` parameter).
2. **Parallel Branch Numbering**: Added unique numbering for each branch in a parallel group (e.g., `-PS01`, `-PS02`), ensuring tag uniqueness and mounting scheme accuracy.
3. **Global Uniqueness Control**: Introduced a system to check `BaseCode` uniqueness across the model. If the same tag is accidentally assigned to different circuits, the tool provides a warning.
4. **Length Calculation for Parallel Systems**: The algorithm now correctly determines cable length based on the longest parallel branch rather than summing them.

2026-07-17
1. **Ducks and Fitting Chains Support**: Redesigned the connection traversal algorithm. The tool now correctly processes fittings connected directly to each other (without straight conduit segments between them).
2. **Crash Fixing**: Resolved the `Sequence contains no elements` error that occurred when analyzing incomplete or empty routes. Added safety checks.

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

