## [26.12] — 2026-09-03
*Sync Conduit Circuit*: Debug lines are created in the `SRS_Placeholders` workset and removed before the next run, on save or synchronize with central, and during hot reload cleanup. Their element IDs are tracked in memory across all documents.

## [26.11] — 2026-09-01
*View history*: Fixed error of navigating in unsaved doc, add notification with the reason if navigation failed.

## [26.10] — 2026-08-27
*Purge*: Fixed duplicate line-style analysis during command initialization and combined detail/model line and schedule analysis into a single progress bar.

## [26.9] — 2026-08-25
*View history*: Improved view history and moved it from the legacy window directly to the ribbon.
*Startup*: Improved dependency loading. An unavailable optional dependency no longer prevents the plugin from starting.
*Assign Conduit to Circuit*: Added writing of the panel and load identifiers, including their locations, to the circuit parameters `SRS_MEP_Conduit_From` and `SRS_MEP_Conduit_To`.

## [26.8] — 2026-08-14
*Startup*: Fixed a startup failure on some Revit 2025 installations where `System.Management` was not supported in the host runtime.

## [26.7] — 2026-08-14
*Sync Conduit Circuit*: Material detection error hotfix: material codes are now detected in both family and type names, so fittings such as `SRS_Conduit_Elbow_RGS: Standard` are grouped with the corresponding RGS conduits when calculating `SRS_MEP_Length`.

## [26.6] — 2026-08-13
*Sync Conduit Circuit*:
1. Locations in conduit parameters: Added the panel and load locations to `SRS_MEP_Conduit_From` and `SRS_MEP_Conduit_To`, respectively, so schedules display the complete equipment identifiers.
2. Material-specific length separation: Conduit and fitting lengths within each segment are separated by the `RGS`, `PVC`, and `FIBERGLASS` codes, rounded up separately to the nearest meter, and written to `SRS_MEP_Length`. Types without a code are handled as a separate group.

## [26.5] — 2026-08-10
Fixed a critical error that prevented the plugin from starting in some Revit versions due to an incompatible `System.Resources.Extensions` dependency.

## [26.4] — 2026-08-07
*Sync Conduit Circuit*: Hotfix for Object reference is nos set.

## [26.3] — 2026-08-06
*Sync Conduit Circuit*: Cable length calculation fix: Fixed an error that caused the ends of conduit chains to be determined in reverse order in some cases. This resulted in incorrect terminal distance calculations.

## [26.2] — 2026-08-03
*Sync Conduit Circuit*:
1. **Terminal Distance Calculation**: Terminal cable distances are now calculated to a virtual point on the opposite vertical edge of the panel or load instead of the equipment insertion point. The target edge is determined from the `Default Elevation` and `SRS_Height` parameters, with `SRS_Height` read from the instance first and then from the type.
2. **Fixed Cable Reserve**: Replaced the percentage-based reserve with a fixed **+2 m** reserve for each route.

## [26.1] — 2026-08-03
Added support for Revit 2026

## [25.52] — 2026-08-03
*Sync Conduit Circuit*: Fix bug: The checkbox to run Sync after Assign no longer affects standalone Sync. The 3D view and selected conduits settings now work independently.

## [25.51] — 2026-07-30
*Sync Conduit Circuit*: Change param name SRS_Length back to SRS_MEP_Length

## [25.50] — 2026-07-30
*Sync Conduit Circuit*:
1. **Configurable 3D View Isolation**: Added "Isolate elements in 3D view" option (default OFF). Allows viewing the route within the building context without hiding other elements.
2. **Enhanced Visualization**: The diagnostic 3D view and selection now automatically include the Electrical Panel (Base Equipment) and all Load elements (Circuit Elements) for a complete system view.
3. **Advanced Debug Logging**: Implemented detailed English logging for cable length calculations. The log now acts as a balance sheet, breaking down lengths of conduits, gaps, terminal distances, and safety margins to ensure calculation accuracy.

*Assign Circuit to Conduits*:
1. **Sync Integration**: Added the "Isolate elements in 3D view" toggle to the assignment UI for a consistent experience when running automatic synchronization.

## [25.49] — 2026-07-29
*Sync Conduit Circuit*: Implemented recording of the segment length into the `SRS_MEP_Length` parameter for each route element. The value is rounded up to the nearest meter. Cable length reserve calculation changed from percentage-based (5-10%) to a fixed value (+2 meters to the total route length).

## [25.48] — 2026-07-24
*Sync Conduit Circuit*: Fixed potential error FileNotFoundException for System.Resources.Extensions.

## [25.47] — 2026-07-23
*Sync Conduit Circuit*: Add support for parallel conduits.

## [25.46] — 2026-07-21
*Create openings*: Transition to Families - instead of native "wall openings", the tool now places Face-Based families to preserve annotations and tags.

## [25.45] — 2026-07-20
*Edit elements in Excel*: Added *Model audit* support - the ability to import data directly from model audit reports. If the standard "Elements" sheet is missing, the user is prompted to select sheets. It then looks for documents by filename in the first column, supporting simultaneous data import into all open Revit documents.

## [25.44] — 2026/07/17
*Model audit*: Coordinates: Fixed angle calculation (Angle to True North) — inverted direction (CCW → CW) to align report data with Revit UI values.
*Sync Conduit Circuit*:
1. **Ducks and Fitting Chains Support**: Redesigned the connection traversal algorithm. The tool now correctly processes fittings connected directly to each other (without straight conduit segments between them).
2. **Crash Fixing**: Resolved the `Sequence contains no elements` error that occurred when analyzing incomplete or empty routes. Added safety checks.

## [25.43] - 2026/07/15
1. **Instance Parameter Priority**: `SRS_Equipment_Type` and `SRS_MEP_Tag_Type_Id` are now sought in the element parameters first, only falling back to Type if empty. This allows instance-level overrides.
2. **Name Cleaning**: Improved `SRS_Schedule_Name` assembly, eliminating trailing/leading hyphens when parameters are partially missing.

## [25.42] - 2026/07/13
*Sync Conduit Circuit*:
1. **Diagnostic 3D View**: Added automatic 3D Review view generation with path isolation, section box cropping, and "Center line" subcategory hiding for better visibility.
2. **Selection Mode**: Added support for processing only manually selected conduits, allowing for precise synchronization of specific sections.
3. **Silent Mode**: Implemented instant execution from the ribbon. Added XOR logic support: hold **Shift** or **Ctrl** to toggle UI visibility regardless of the "Show UI" setting.

*Assign Circuit to Conduits*:
1. **Simple Mode**: Added an option to overwrite existing circuits in conduits (clears the parameter before assignment).
2. **Silent Mode**: Integrated instant launch support with Shift/Ctrl inversion.
3. **Run Sync**: Added toggle to automatically run the Sync tool and open the 3D Review view immediately after assignment.

## [25.41] - 2026/07/09
*Sync Conduit Circuit*:
1. Refined segment naming: if panel and load locations differ, both are specified (`Loc1-From/Loc2-To-Tag`); if they match, only one prefix is used.
2. Removed "CC" abbreviation from conduit tags for brevity.
3. Implemented upward rounding of calculated cable length to the nearest meter (`Math.Ceiling`) with a reserve factor (1.10 for ≤100m, 1.05 for >100m).
4. Automated location prefix selection (e.g., 18D) based on `Functional_Breakdown_Code` parameter, removing the need for manual default location setting.

*Assign Circuit to Conduits*: Implemented automatic location prefix detection based on `Functional_Breakdown_Code` mapping, ensuring naming consistency with `Sync Conduit Circuit`.

*Create View Filters*: tool allows for the batch creation and modification of view filters using Excel.

## [25.40] - 2026/07/07
*Create Security Devices*: (formerly *Create Fire Alarm Devices*) Added CCTV support as a new discipline.

## [25.39] - 2026/06/30
*Model Audit*:
1. Merged `SiteLocations` and `BasePoints` into a single `Coordinates` check; removed redundant `WorksetElements` check.
2. Optimized `TitleBlocks` and `Revisions` reports by aggregating data into summary counts (`InstanceCount`/`SheetCount`), reducing output size.
3. Enhanced `Views` report by duplicating data across 5 additional sub-sheets grouped by `ViewType` (Plans, Cuts, 3D, Schedules, Others).
4. Implemented `Units` comparison matrix (`Mun`) showing unit deviations from metric defaults across all projects.
5. Added `CurrentRevisionId` column to `Sheets` report.
6. `LinksRvt` matrix now highlights cells in yellow if a host file contains duplicate instances of the same link.
7. Introduced interactive HTML visualization for `Viewports` (sheet `vpE`), showing distribution of TitleBlocks and viewport types across sheets.

*Create print set*: fixed sorting.

## [25.38] - 2026/06/19
*Sync Conduit Circuit*: Fixed error when `SRS_Schedule_Name` was missing on equipment or `SRS_Location` was empty (now defaults to '18D'). Parameter names moved to settings.
*Assign Circuit to Conduits*: Fixed circuit detection for elements that are intermediate panels. Parameter names moved to settings to `SyncConduitCircuit` section in `%AppData%\Sener\BimTools\Settings.json`

## [25.37] - 2026/06/16
*Create fire alarm devices*: Added intrusion sensors (volumetric detectors and magnetic contacts).
*Balance Panels*: Added new tool designed to analyze the panel hierarchy and automatically redistribute circuits to minimize phase load imbalance.

## [25.36] - 2026/06/11
*Purge*: support old Revit (2019-2023) cleanup of auto-generated "Default" materials.
*Model audit*: fix error (Object reference...) for Areas, Views, Rooms.
*Sync air flow to schematic*: Added user interface with step-by-step separation and Name Shortener. Fixed bug with duplication of heat exchangers when multiple schematics contain the same room.

## [25.35] - 2026/05/14
New command *Align Elevations*: Groups lighting fixtures by space and type, computes the average elevation from a configurable source parameter, rounds it to a configurable step (default 50 mm), and writes the result to a target parameter — eliminating "Various" in schedules. Fixtures without an assigned space are skipped. Automatically detects Length vs Number parameter type and converts units accordingly. Report dialog shows total stats; details (groups with range ≥ 1 mm and more than 1 fixture) are collapsed under a spoiler (up to 20 lines) and saved in full to a CSV file.

## [25.34] - 2026/05/14
*Model audit*: Sheets and Views - reports now include grouping parameters from the active Browser Organization, inserted between the main and custom columns.
*Model audit*: Built-in parameters previously set via config are now always included as hardcoded (e.g. IFC for families, Area Type/Design Option/Comments for Areas, etc.). This ensures correct operation regardless of Revit language; other parameters can still be added via config.
*Model audit*: FamInstances and FamTypes: type parameters are no longer shown for family instances in reports.
*Model audit*: New "Use relative path" option — save report next to the config file (`[ConfigDir]/Reports/ModelName.xlsx`). On each overwrite the previous file is automatically backed up to `[ConfigDir]/Reports/backup/`. Checkbox is disabled when no config file is selected or the file does not exist.

## [25.33] - 2026/05/07
*Fill Code*: Added support for elements without elevation like `Piping Systems`. If Z cannot be determined for an element, FillCode now uses Z=0.
*Autoupdate*: Now the plugin updates fully automatically - there are no notifications about new versions, updates are downloaded silently in the background and applied at the next Revit launch. You can disable auto-update in the Info window. You can also apply updates instantly (hot-reload) without restarting Revit.

## [25.32] - 2026/04/20
*Model audit*: Fixed the LinksDwg transaction error.
*Model audit*: Check errors no longer stop the entire audit. If a check fails, the remaining checks continue to run. The Summary sheet shows error message for the failed check.

## [25.31] - 2026/04/13
*Model audit*: Fixed an error that occurred when auditing projects with nested linked models. The RVT Links check now correctly processes all levels of Revit links.

## [25.30] - 2026/04/07
*Model audit*: total improvement

## [25.29] - 2026/03/31
*Fill Code*: Fixed processing of Revit subcategories (e.g. `Floors: Slab Edges`, `Walls: Wall Sweeps`, `Stairs: Supports`, `Roofs: Fascias`, `Roofs: Gutters`). Elements of these categories were silently skipped due to subcategory not being found during collection.

## [25.28] - 2026/03/16
Add new command *Model audit*: Audit the current Revit model and all loaded links - generates an Excel report with 31 checks
*Circuit description*: Add R5 equipment marking feature, adds asterisk (*) to the beginning of Load Name.
Fix error of blocked settings.json

## [25.27] - 2026/02/20
*Sync equip to schematic*: Fixed an error ('An item with the same key has already been added') that occurred when multiple instances of the same Revit link were present in the project.

## [25.26] - 2026/02/20
*Sync power params*: Fixed error Object reference not set to an instance of an object (line 381).
*Sync power params*: Implemented selection-based filtering for sockets. The command now processes only selected electrical fixtures and equipment if a selection is active; otherwise, it processes all relevant elements in the project.

## [25.25] - 2026/02/13
*Fill Code*: Changed level SEA to FND in all models.

## [25.24] - 2026/02/13
Add new command *Upload to ACC*: batch upload models to Autodesk Construction Cloud
*Create Hangers*: fix sizing error, recently introduced
*Clone&Shift*: param window fix
*Circuit description*: Fixed the logic for saving user input for unknown rooms ("?").

## [25.23] - 2026/01/20
*Sync air flow to schematic*: Fixed an issue where unit heater annotations were created on the wrong view when multiple views contained the same rooms. Annotations are now created on the active view, even if they already exist on other views.

## [25.22] - 2026/01/19
*Circuit description*: Fixed an issue where equipment counts with two or more digits (LTG × 12) were incorrectly shortened to single digits (LTG2).

## [25.21] - 2026/01/19
*Sync air flow to schematic*: The logic for unit heater synchronization has been simplified. Now, all types of the families specified in the settings are processed, and the type name in the configuration is ignored.

## [25.20] - 2026/01/19
*Sync air flow to schematic*: Add air heaters support

## [25.19] - 2026/01/15
*Fill code*: Enhanced with a more flexible and readable column-based format for level mappings in Excel. The command now also supports differentiated level codes based on the building code from the project name, with a fallback mechanism for backward compatibility.
*Cad to Revit*: Fix missed ACadSharp.dll error. Fix error Specified argument was out of the range of valid values. Publish docs

## [25.18] - 2026/01/12
Add new command *Fill code*: The command is designed to automatically generate and assign a unique identification code to elements in a Revit model. The code is created based on a set of rules that can be configured using an external Excel file and is written to the element's `IDD_PDS_CODE` parameter.

## [25.17] - 2026/01/12
Add new command *Create openings*: The command automates the process of creating and updating openings in walls for the passage of MEP elements. It analyzes intersections, considers existing openings, merges closely located new openings, and generates a detailed report on the actions performed

## [25.16] - 2025/12/23
*Transfer Lighting Data To Space*: Split to two modes, Normal and Emergency.

## [25.15] - 2025/12/22
Add new command *Transfer Lighting Data To Space*: Copies lighting analysis parameters from a generic model to the space it occupies. See [the docs](https://snrbim.github.io/es/docs/transfer-lighting-data-to-space/).

## [25.14] - 2025/12/03
*Assign spaces to equipment*: Added the Duct Accessories category; added the ability to change the parameter name (in settings.json).

## [25.13] - 2025/12/03
Add new command *Position Check*: tracks equipment position and size changes between model snapshots.
Fix error Could not load file or assembly EPPlus

## [25.12] - 2025/11/27
*Count sockets*: The logic for counting single sockets has been changed; now elements are considered as such only if their name contains the word single.

## [25.11] - 2025/11/24
*Purge*: Add families deletion.

## [25.10] - 2025/11/21
*Purge*: Add material duplicates deletion.

## [25.9] - 2025/11/20
*Sync fire alarm diagram*: Add family mapping pre-population.

## [25.8] - 2025/11/19
*Sync fire alarm diagram*: Add configurable family mapping.
*Sync fire alarm diagram*: Add option to create empty rooms.
*Sync fire alarm diagram*: Add Manual placement param support.
*Sync fire alarm diagram*: Reverse levels to natural order, highest on top.
*Sync fire alarm diagram*: Not mark as moved if SourceRoomId was empty.
*Sync fire alarm diagram*: Limit levels.
*Set ASHRAE code*: Fix for the issue of recalculation not occurring.

## [25.7] - 2025/11/12
*Sync equip to schematic* and *Assign Equip to Schematic* fix reading parameter SRS_Equipment_Type from instance.

## [25.6] - 2025/11/12
*Sync equip to schematic*: Added support for reading parameter SRS_Equipment_Type from instance if not found on family type. Changed parameter reading to use default values instead of throwing exceptions.

## [25.5] - 2025/11/11
*Assign Equip to Schematic*: Added support for reading parameter SRS_Equipment_Type from instance if not found on family type. Changed parameter reading to use default values instead of throwing exceptions.

## [25.4] - 2025/10/30
*Purge*: Fixed an issue where views were deleted even if their dependent views were on a sheet or in the ignore list.

## [25.3] - 2025/10/28
Add new command *Cad to Revit*:
EN: Creates Revit family instances from DWG blocks based on an Excel mapping table.
ES: Crea instancias de familias de Revit a partir de bloques DWG según una tabla de correspondencia en Excel.
*Circuit description*: Added support for custom equipment codes for Lighting Fixtures via SRS_MEP_Equipment_Code parameter.
*Circuit description*: Skip circuits without elements (space/spare circuits) to prevent renaming them.
*Edit elements in Excel*: Add a menu item to include ProjectInfo sheet to the excel output.
Add new command *Sync fire alarm diagram*:
EN: The command is designed for the automatic creation and subsequent synchronization of a 2D fire alarm device layout diagram based on a 3D model. It generates 2D elements on a drafting view corresponding to rooms and devices, and tracks changes in the model, updating the diagram.
ES: El comando está diseñado para la creación automática y posterior sincronización de un diagrama de diseño de dispositivos de alarma contra incendios en 2D basado en un modelo 3D. Genera elementos 2D en una vista de dibujo correspondientes a habitaciones y dispositivos, y rastrea los cambios en el modelo, actualizando el diagrama.

## [25.2] - 2025/10/10
*Edit elements in Excel*: non-parameter Space: split info into number and name. Fix SpaceId.
*Edit elements in Excel*: add similar non-parameters for Room info.
New general feature: when a user runs a command and a new update is available, a dialog appears offering to download and install the update, with the ability to postpone.
*Purge*: Added an "Ignore list" to prevent the deletion of specific views. Rules can be defined in the format `ParameterName: Value`. The ignore list can be auto-generated based on the current Project Browser organization settings via a new menu. The ignore list content is saved between Revit sessions. Also, added a progress bar to AnalyzeLineStyles.
*Purge*: Fix the issue of legends being constantly deleted.
*Convert lines to wires*: fix wire creation logic for crazy families with tags inside. Add view range offsets.

## [25.1] - 2025/09/23
*Show CADs*: Updatedd logic with Linked dependent on cloud status

## [25.0] - 2025/09/22
Add new command *Create print set*
Add new command *Show CADs*

## [24.1] - 2025/09/18
*Convert lines to wires*: Fix error The referenced object is not valid... at line 801.

## [24.0] - 2025/09/17
Add new command *Convert lines to wires*: Converts drawn lines into electrical wires, automatically finding devices and connectors to connect the wires.

## [23.14] - 2025/09/04
*Circuit description*: RCT abbreviature changed to RECPT

## [23.13] - 2025/09/01
*Sync air flow to schematic*: Fix family names SRS_Hvc_Generic_Annotations_Diffuser and SRS_Generic_Annotations_Schematic_Room.

## [23.12] - 2025/08/28
*Circuit description*: Added support for both the type and instance parameter SRS_MEP_Equipment_Code.

## [23.11] - 2025/08/28
*Assign circuit to conduits*: Parameter name "SRS_MEP_Location" changed to "SRS_Location".

## [23.10] - 2025/08/27
*Circuit description*: Parameter name "SRS_MEP_Equipment_Number" changed to "SRS_Equipment_Number".

## [23.9] - 2025/08/27
*Circuit description*: The command now more accurately identifies equipment categories and parameters to read. For Electrical Equipment, the "SRS_Schedule_Name" parameter is used. For Electrical Fixtures, the "SRS_MEP_Equipment_Code" + "SRS_MEP_Equipment_Number" parameters are used. For Lighting Fixtures, "LTG" is used. For other categories, "RCT" is used by default.

## [23.8] - 2025/08/14
*Sync space params*: Fixed room search error - the target point was conditionally raised by 1 foot to avoid collision with the floor structure

## [23.7] - 2025/08/14
*Create Hangers*: Change in operation logic: abandoning face-based families in favor of standard ones.
*Circuit description*: Fixed "The referenced object is not valid" error that occurred because the memory was not cleared between command runs. This led to attempts to access invalid elements from previous sessions.

## [23.6] - 2025/08/11
*Sync air flow to schematic*: Added a call to the 'Assign spaces to equipment' command, so the user no longer needs to run it beforehand.
*Sync air flow to schematic*: Added support for annotations of a single room across multiple views with different systems.

## [23.5] - 2025/08/08
*Sync air flow to schematic*: now correctly handles cases where a room has air terminals from multiple different systems.

## [23.4] - 2025/08/07
*Edit elements in Excel*: Add Edit as txt file feature.
*Circuit description*: Now pays attencion to Spatial Element Calculation Point when looks for a space.
*Circuit description*: Preserve manual room edits.

## [23.3] - 2025/07/17
*Sync Equip to Schematic*, *Assign Equip to Schematic*: Extract settings to %AppData%\Sener\BimTools\Settings.json.

## [23.2] - 2025/07/14
*Sync Equip to Schematic*, *Assign Equip to Schematic*: Removed MEP_ from param names for the logic for filling the 'SRS_MEP_Equipment' parameter for schematic annotations; now it uses the format 'SRS_Location-SRS_Equipment_Type-SRS_Equipment_Number'.

## [23.1] - 2025/07/09
*Create sockets*: Add ability to place sockets every 20 m when `SRS_MEP_Receptacles` parameter is set to "AS REQ'D".
*Create sockets*: Extract settings to %AppData%\Sener\BimTools\Settings.json.

## [23.0] - 2025/07/09
Add new commands *Assign spaces to equipment*, *Sync air flow to schematic*, *Sync space params*

## [22.3] - 2025/07/08
*Sync Equip to Schematic*, *Assign Equip to Schematic*: Updated the logic for filling the 'SRS_MEP_Equipment' parameter for schematic annotations; now it uses the format 'SRS_MEP_Location-SRS_MEP_Equipment_Type-SRS_MEP_Equipment_Number'.

## [22.2] - 2025/06/30
*Set project params*: Excel path history has been added.

## [22.1] - 2025/06/27
Add new command *Set project params*

## [22.0] - 2025/06/17
Add new command *Clone&Shift*

## [21.10] - 2025/06/04
*Sync power params*: add SRS_MEP_Fire_Life_System param. Ground bar elevation is increased form 400 to 600 mm.

## [21.9] - 2025/05/27
*Sync Equip to Schematic*: Rename family from SNR_SignalStatus to SRS_SignalStatus.

## [21.8] - 2025/05/27
*Sync Equip to Schematic*:
Copy equipment code to SRS_MEP_Equipment parameter of signal for filtering purposes.
rename family from SNR_SignalStatus_Temporal to SNR_SignalStatus.
Visualization is skipped if the active view's SNR_BRW_ViewGroup parameter is not "WIP" or "Work In Progress" (case-insensitive).

## [21.7] - 2025/05/22
*Create sockets*:
Added support for worksets. Now sockets, switches and ground bars are placed in different worksets.
Rename Normal_XWay params to Normal_XWay(Surface).
Rotate ground bar and switches to 90°.

## [21.6] - 2025/05/21
*Sync Equip to Schematic*: prevent tool from trying to read SNR_SignalStatus_Temporal families instead of actual signals.
*Assign Equip to Schematic*: If the active view is not a floor plan view, and only one floor plan view is open, it will be automatically activated to create the status family on it.

## [21.5] - 2025/05/21
*Sync Equip to Schematic*: Rename parameter SRS_MEP_RoomID from to SRS_MEP_Room_Id.

## [21.4] - 2025/05/21
*Assign Equip to Schematic*: Remove family name from SRS_MEP_Equipment_Id.

## [21.3] - 2025/05/20
*Assign Equip to Schematic*: Added status visualization.

## [21.2] - 2025/05/19
*Sync power params*: Added automatic calculation of the `SRS_MEP_Electrical_FLA` parameter when its value is 0, based on `Wattage`, `Volts`, and `Power Factor`. Supports both single-phase and three-phase connections.

## [21.1] - 2025/05/19
*Create sockets*: Add room separator support.

## [21.0] - 2025/05/16
Add new command *Create sockets*

## [20.4] - 2025/05/06
*Sync power params*: ignore clashsed with imported DWGs.
*Sync power params*: ignore clash if the elem belongs to the workset which is not visible in all views.
*Sync power params*: Minor clashes (up to 1 mm) are no longer taken into account.

## [20.3] - 2025/05/06
*Sync power params*: fixed parameter handling for _2 and _3 params.

## [20.2] - 2025/05/05
*Sync power params*: fixed error: Nullable object must have a value at Utils.LookupParam.

## [20.1] - 2025/04/30
*Assign Equip to Schematic*: button text is fixed.

## [20.0] - 2025/04/29
New Commands Added (Revit 2025 only):
*Assign Equip to Schematic*: links selected equipment to schematic annotations by writing its ID and source model into parameters.
*Sync Equip to Schematic*: updates schematic annotations with current location and level data based on previously linked equipment.

## [19.0] - 2025/04/24
*Edit elements in Excel*: Added pseudo-parameters (read-only):
1. WorksharingInfo – who created and last modified the element
2. HostId – the wall hosting the window
3. TagOwnerId – the element to which the tag belongs
4. TagText – the final tag text
5. Coordinates – the element's coordinates in meters
6. TextContent – contents of text elements
7. Space – name and number of the space containing the element
8. SpaceId – ID of the space
*Sync power params*: Plugin now reads matching parameters paramdName_2, paramdName_3, based on code suffix *2 or *3

## [18.7] - 2025/04/03
*Conduit circuit sync*: Added recording of short names (part after the penultimate dash) of electrical circuit components in the SRS_MEP_Comments parameter of the circuit.

## [18.6] - 2025/04/02
*Conduit circuit sync*: The component name of the circuit, such as 18D-DS-SF01, 18D-DS-SFxx, is now recorded in the SRS_Schedule_Name parameter of the circuit

## [18.5] - 2025/04/02
*Conduit circuit sync* and *Assign circuit to conduits*: Fixed the error made in v18.4, now
SRS_Equipment_Type is used to combine the SRS_Schedule_Name parameter
SRS_MEP_Tag_Type_Id (formerly SRS_MEP_System) is used for the code after the letters -CC-

## [18.4] - 2025/04/01
*Info*: Fixed error of clicking items in the Extra menu in Revit 2025.
*Info*: Fixed error A newer version of BimTools is already installed.
*Conduit circuit sync*: Added option to use SRS_MEP_Tag_Type_Id parameter instead of SRS_Equipment_Type. Now both params are supported. Prioriti is for SRS_MEP_Tag_Type_Id.

## [18.3] - 2025/03/31
*Conduit circuit sync*: The default value of the SRS_Location parameter has been corrected from 18D to ??D.

## [18.2] - 2025/03/26
*Sync power params*:
1. The ability to use repeating codes has been added (for example, for racks). To do this, the asterisk symbol should be used:
    Equip01, Equip01*suffix, Equip01*3, Equip01*abc.
On one hand, the algorithm will only consider the part before the asterisk; on the other hand, it will not register this as a duplicate code error.
2. A new Clash column has been added, which contains the ID and category of detected clashes. The cells include a hyperlink that, when clicked, navigates to the corresponding row in the expanded clash report, where additional information is provided: the name of the related project and the family type.
3. A new VφError column has also been added. It contains a label indicating a mismatch between voltage and phase count. If these two socket parameters are not editable (e.g., the socket is connected to a circuit) and their values differ from those in the associated equipment, the column will display the ✗ symbol.

## [18.1] - 2025/03/25
Fix error *Could not load file or assembly 'Microsoft-Windows-SDK-NET*

## [18.0] - 2025/03/20
Add new commands *Assign circuit to conduits* and *Conduit circuit sync*

## [17.6] - 2025/02/24
*Sync power params*: Fixed excel reading error if old report is open

## [17.5] - 2025/02/24
*Sync power params*:
1. Fixed duplication error in the report
2. Fixed unit of measurement error (volts and watts)
3. Added columns to the report: SocketLocation, EquipLocation, FirstReport

## [17.4] - 2025/02/19
1. Fix error 'IBM437 is not a supported encoding name'
2. Add new command *Sync power params*

**Descripción del algoritmo de funcionamiento del comando Sync Power Params**

1. Obtener todos los tomacorrientes del proyecto actual (todas las familias de las categorías *Electrical Fixtures* y *Electrical Equipment* que tengan el parámetro `SRS_MEP_Equipment_Code`).
2. Obtener el equipo: todas las familias cargables (no sistémicas) de los proyectos vinculados que tengan el parámetro `SRS_MEP_Equipment_Code`. Los vínculos deben estar cargados.
3. En un ciclo, para cada código de equipo (valores del parámetro `SRS_MEP_Equipment_Code`):
   3.1. Se determina la familia de equipo correspondiente al tomacorriente y se leen los valores de los siguientes parámetros:
   - 1 `SRS_MEP_Volts`
   - 2 `SRS_MEP_Phase`
   - 3 `SRS_MEP_Hertz`
   - 4 `SRS_MEP_Connection_Type`
   - 5 `SRS_MEP_Wattage`
   - 6 `SRS_MEP_Power_Factor`
   - 7 `SRS_MEP_Electrical_FLA`
   - 8 `SRS_MEP_Efficiency`
   - 9 `SRS_MEP_Utilization_Factor`
   3.2. Si un código tiene asociado un solo tomacorriente y un solo equipo, los nuevos valores del equipo se escriben en el tomacorriente.

Paralelamente a este algoritmo, se genera un informe en formato Excel que se guarda en la carpeta `%APPDATA%\Sener\BimTools\Reports\SyncPowerParams` y se abre si el usuario hace clic en la notificación del resultado.

**Explicación del informe:**
- La columna `isUpdated` contiene una marca si los parámetros fueron escritos en el tomacorriente.
- Los nuevos valores, si son diferentes de los antiguos, se resaltan en verde o rojo según el valor de la columna `isUpdated`.
- Se usa el símbolo 🚫 si el parámetro no está presente.
- Si para un código de tomacorriente se encuentran varios equipos, se enumeran todos los valores únicos de sus parámetros.
- La columna `FirstReport` muestra la fecha en que se exportó el elemento si se encontró en un informe anterior. Permite filtrar nuevos elementos.
- Las columnas `SocketLocation` y `EquipLocation` contienen el número y el nombre del espacio Revit según el archivo actual para `SocketLocation` y el archivo vinculado para `EquipLocation`. Si no se encuentra el espacio, se indican las coordenadas.

## [17.3] - 2025/02/10
Add new command *Circuit description*

Herramienta para la creación automática de descripciones uniformes e informativas de los circuitos eléctricos

Cómo usarla:
Abre la tabla del panel eléctrico (Panel Schedule) en Revit. Se admite la selección de varias tablas en el navegador del proyecto.
Haz clic en este botón en la cinta.

El plugin analiza todos los elementos conectados en los circuitos eléctricos de los paneles seleccionados. Se lee el código del equipo:
- Para la categoría ElectricalEquipment, se toma el parámetro "SRS_Schedule_Name"
- Para la categoría LightingFixtures, se usa "LTG"
- Para las demás categorías, se usa "RCT"

Genera una descripción para cada circuito en el formato: "Código del equipo × Cantidad | Número de habitación × Cantidad"
Por ejemplo: "LTG × 2, RCT × 1 | 101 × 2, 102 × 1", donde LTG significa iluminación y RCT las demás categorías.

Al finalizar, aparecerá una notificación con la cantidad de circuitos procesados
Se generará un informe en Excel con información detallada sobre los cambios
Para abrir el informe, haz clic en la notificación

Aspectos importantes:
El plugin determina la ubicación del equipo según los espacios MEP (MEP Spaces)
Si el dispositivo está fuera de un espacio MEP, se usará el parámetro de ubicación de Revit
Para ubicaciones indefinidas, se usará el símbolo "?"
Los circuitos sin cambios se marcan en el informe con "="

## [17.2] - 2024/12/03
1. Fix ribbon load error.

## [17.1] - 2024/12/02
1. *Count sockets*: Updated socket counting logic for single and twin sockets. New logic treats sockets without "twin" in famName as "single" by default for more consistent counting.
2. *Count sockets*: added writing of the element count for each family to a text parameter, as well as location.
3. *Count sockets*: type name is considered also in addition to family name
4. *Create dampers*: add ability to control whether to process walls without fire rating. Previously they were skipped.

## [17.0] - 2024/08/08
1. *Edit elements in Excel*: add Update File feature.
2. Add new command *TextoMorph*
3. Add autoupdate feature
4. Add new command *Count sockets*

## [16.6] - 2024/05/22
1. *Purge*: fix unused templates detection issue.
2. *Purge*: consider schedules as views.
3. Add Revit 2024 support.

## [16.5] - 2024/04/17
1. *Convert curves to rebar*: add parameter transfer feature. The tool reads generic model Mark param and writes the content to specified (in the UI) parameter.

## [16.4] - 2024/04/10
1. *Convert curves to rebar*: fix the error: The input solid is not a closed geometric volume.

## [16.3] - 2024/04/09
1. *Set ASHRAE code*: add SpecificLoss setting. A new column introduced, for value (Pa) or paramName.
2. *Edit elements in Excel*: now remembers selected parameters and last elements, understands if Excel is open already, improved UI.
3. Add UI to installer
4. Change installer and docs links from gdrive to snr local network

## [16.2] - 2024/03/12
1. *Set ASHRAE code*: add duct accessories support

## [16.1] - 2024/03/01
1. Plugin usage statistics improvement
2. *Convert curves to rebar*: Orient hooks to center
3. *Convert curves to rebar*: Clarify error reporting
4. *Info*: Add Open installers folder button

## [16.0] - 2024/02/06
1. *Tag elements on views*: Add linear elements support
2. *Create dampers*: Add moved links support
3. *Create dampers*: Add multiple intersections support
4. *Create dampers*: Fix error of comma as a system decimal separator
5. *Create dampers*: Progress bar appears just if more than 10 ducts
6. *Create dampers*: Change param to builtin one - FIRE_RATING (is absent for the floors).
7. *Edit elements in Excel*: Fix read-write bugs.
8. Add new feature *View history*
9. Add context help links to F1 feature.

## [15.0] - 2024/01/24
1. Add new command *Edit elements in Excel*
2. Add new command *Change level*
3. *Selection History*: Add Section Box History feature
4. *Create along path*: Add Pipe, Duct, CableTray, Conduit support
5. *Create along path*: Fix PK's unnecessary precision
6. *Create along path*: Fix parameters units
7. *Create dampers*: Add user selection support

## [14.3] - 2024/01/02
1. *Convert curves to rebar*: Fix polyline error

## [14.2] - 2023/12/21
1. *Convert curves to rebar*: Fix null error after first run

## [14.1] - 2023/12/20
1. *Create Hangers*: Fix hanger list filtering
2. *Tag elements on views*: Fix null-reference error
3. *Create dampers*: Improve logic

## [14.0] - 2023/12/20
1. *Create Hangers*: Add relative commands - Align and Rotate
2. *Create Hangers*: Add relative commands - distance markers toggling and Adjust
3. Add new command *Create dampers*

## [13.0] - 2023/12/13
1. *Info*: Add update plugin feature
2. *Create Hangers*: Add Max distance parameter
3. *Create along path* Fix strange behavior with coordinates.

## [12.1] - 2023/12/05
1. *Create Hangers*: Hide unnecessary types from the combobox (model parameter is "Drilling Point" or "Hanger Part" or "Miscellaneous")

## [12.0] - 2023/12/05
1. *Create along path*: Replace deleting by moving
2. *Selection History*: Suppress the error message
3. *Convert curves to rebar*: Add hook types and orientation

## [0.11.0] - 2023/11/29
1. Add new command *Convert curves to rebar*
2. *Set ASHRAE code*: Fix NumberDecimalSeparator bug once more
3. *Set ASHRAE code*: Add the synonyms feature
4. *Create along path*: Fix ElementCodes numbering
5. *Create along path*: Add wrapper feature
6. *Create along path*: Fix deleting issue
7. *Create worksets from Excel*: Create view even for existing worksets, if they are in excel
8. *Tag elements on views*: now requires multicategory tag

## [0.10.0] - 2023/11/17
1. Add *Create worksets from Excel* command
2. *Set ASHRAE code*: Fix <= and >= error. Clarify warning message
3. *Set ASHRAE code*: Fix NumberDecimalSeparator bug
4. *Set ASHRAE code*: Now considers current selection.
5. *Purge*: Add Text types and Line styles

## [0.9.0] - 2023/11/14
1. *Create Hangers*: Add rotate round hangers feature

## [0.8.2] - 2023/11/03
1. *Create along path*: Fix error when run more than once
2. Other improvements

## [0.8.1] - 2023/10/31
1. *Create along path* command: Improve codes numbering to correspond to PKs
1. *Create along path* command: exclude empty schedules.

## [0.8.0] - 2023/10/31
1. *Create along path* command improved:  
Add export of created elements;  
Scope box detection and filling according parameter.
1. Add *Read parameters from Excel* command.  
2. Add *Tag elements on views* command.

## [0.7.1] - 2023/10/17
Improved *Create along path* command.

## [0.7.0] - 2023/10/04
Add *Create along path* command.

## [0.6.0] - 2023.08.16
Add *Selection History* command.

## [0.5.4] - 2023.07.21 (patch)
1. Rename *Set loss method* command to *Set ASHRAE code*.
1. Improved reliability of *Set ASHRAE code* in case of zero-flow fittings. Now they are showed in the report and do not block further calculations.

## [0.5.2] - 2023.07.19 (patch)
1. Fixed wrong behavior of *Set loss method*, when you need to restart Revit to override the table by txt, or update txt. Now you don't need.

## [0.5.1] - 2023.07.18
1. *Set loss method* command is fixed:
   Angle - can be a type parameter;
   System - can be multiple (divider is comma);
   System - project can be in any language;
   Diameter - takes the max diameter from tees;
   Added the Ignore feature (hides items in the report).

## [0.5.0] - 2023.07.09
1. The new *Purge* command is added.

## [0.4.0] - 2023.06.05
1. *Set loss method* - add feature selecting ASHRAE code from Excel by parameters (instead of relying on type name).
1. *Info* - add button to the Suggest improvements Google Form.

## [0.3.1] - 2023.05.22
*Create Hangers* - fix a problem with setting *Distance To* param in Revit versions < 23.

## [0.3.0] - 2023.05.22
1. Added the *Create Hangers* command.
1. Added changelog to *Info* window.

## [0.2.0] - 2023.04.13
Added the *Set loss method* command. Here is its logic:
```
1. Gets all duct fittings.
2. For every fitting:
3.     Parses type name for ASHRAE table name (patterns like A1-23, CDE456-789).
4.     If no table name found
5.         Continues to the next fitting.
6.     If a table name found:
7.         Sets fitting's loss method to Coefficient From ASHRAE Table.
8.         Sets fitting's ASHRAE table name.
9. Exits.
```
Known misbehaviour: the found table name will be set anyway even if it isn't applicable. Revit UI doesn't allow it to user by disabling inappropriate options. There is no way to do any similar validation with API.

## [0.1.0] - 2023.03.31
Added the first command *P&ID Linker*.

