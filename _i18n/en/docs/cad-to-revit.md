# CadToRevit: Place and Sync Family Instances from CAD Blocks
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

This tool is designed to automatically create and update Revit family instances based on blocks from DWG files. It allows you to significantly speed up the process of transferring data from 2D drawings to a 3D model and keep it up to date.

## Key Features

- **Batch creation and updating:** Fast processing of a large number of blocks.
- **Flexible mapping:** Configure the correspondence between CAD blocks and Revit families using Excel.
- **Height control:** Precise control over the placement height using multiple levels of settings.
- **Duplicate handling:** Intelligent filtering of duplicate blocks.
- **Detailed reports:** Generation of Excel reports on created, updated, and skipped elements.

## Workflow

### Step 1: Preparation and Analysis (button "Prepare/Update...")

At this stage, the tool analyzes the selected DWG files and the current Revit project, and then creates or updates the Excel mapping file. This file contains not only the configuration table but also several helper sheets.

**Main configuration sheet:**
- **`Block-Family Mapping`:** This is the main worksheet where you manually define which CAD block corresponds to which Revit family.

**Helper sheets (read-only):**
- **`Blocks`:** Contains a complete list of all unique blocks found in the specified DWG files, their counts, and all their attributes. Use it as a reference to copy the exact block names for mapping.
- **`Families`** and **`Families (Transposed)`:** Two sheets representing the same data in different formats. They list all compatible families found in the Revit project and their writable parameters. They help in choosing the correct family and parameter names for mapping.
- **`Comparison`:** Shows the changes in the block composition (added, removed, modified) between the last two analysis runs.
- **`Duplicates`:** Provides detailed information about all found duplicate blocks, indicating which one was used and which were ignored.

### Step 2: Configure Mapping

Edit the **`Block-Family Mapping`** sheet, filling in at least the three mandatory columns: `BlockName`, `FamilyName`, `FamilyType`.

### Step 3: Create Elements (button "Create Families")

After configuring the mapping, start the creation process. The tool will place families in the model according to your rules and generate a final Excel report.

## UI Overview

![UI](image.png)

- **Input Fields:** A large text box for DWG file paths (you can paste multiple paths, each on a new line) and a field for the Excel mapping file path.
- **"..." Menu Buttons**: To the right of each input field, there is a `...` button that opens a menu on a **left-click**:
    - **For DWG:**
        - `Add new path(s)...`: Opens a dialog to select DWG files.
        - `Recent Files`: Shows a list of recently used files for quick access.
    - **For Excel:**
        - `Select new path...`: Opens a dialog to select an Excel file.
        - `Generate default path`: **Automatically creates a path** for the mapping file in the plugin's reports folder (`%AppData%\Sener\BimTools\Reports\CadToRevit\`). The file will be named `mapping_<project_name>.xlsx`.
        - `Recent Files`: A list of recent mapping files.
- **Hotkeys:**
    - **Enter**: Starts the family creation process (`Create Families`).
    - **Esc**: Closes the window (`Cancel`).

## Updating and Synchronization

When run again, the tool does not recreate elements but updates existing ones by tracking changes.

- **Link:** The tool tracks the created elements using the **"DWG info"** service parameter, which is written to each family. **Do not delete or modify this parameter.**
- **Change Detection:** Synchronization is triggered if there are changes in:
  - **Position:** The element's offset exceeds 100 mm.
  - **Rotation:** The rotation angle has changed by more than 0.1°.
  - **Parameters:** The value of at least one of the tracked parameters has changed.
- **"Orphaned" Elements:** If a block has been deleted from the DWG, the corresponding element in Revit is not deleted but is marked in the report as "Orphaned". This allows for a manual decision on deletion.

## Placement Height Logic (Offset Z)

The element's height is determined by a three-level priority system:

1.  **`offset` attribute in CAD block (Highest priority):** If the block has an `offset` attribute, its value is used for the height. Values > 5 are considered millimeters; ≤ 5 are considered meters.
2.  **`DefaultZ (mm)` column in Excel (Medium priority):** If the attribute is not present, the value from this column is used.
3.  **Default by category (Lowest priority):** If nothing is specified, the default height for the family's category is applied:
    - **Lighting Fixtures** (`OST_LightingFixtures`): `2999 mm`
    - **Lighting Devices** (`OST_LightingDevices`): `999 mm`
    - **All other categories:** `99 mm`

## Additional Features and Important Notes

- **Working with Views and Cropping:** The tool processes not just linked DWG files from the link manager, but their specific **instances placed on views** (primarily floor plans). This is a key mechanism for correctly correlating coordinates when a single DWG file contains multiple floor plans offset from each other.
    - **Your Action:** Before running the tool, you must **manually place and align** each instance of the linked DWG on the corresponding plan view in Revit.
    - **Tool's Action:** The tool reads the transformation (offset and rotation) of each instance and correctly calculates the block positions in the shared Revit coordinate system.
    - **Filtering:** Additionally, you will have to use the **Crop Box** on the view to limit processing to only the desired part of the DWG. Blocks outside the crop box will be ignored for that level.
    - **Verification:** You can check if your setup is correct on the **`Blocks`** sheet in the Excel file. For each block, it shows the number of its occurrences on each view (in "View: <View Name>" columns). If the count does not match your expectations, check the alignment and crop boundaries of the DWG link.
- **"Corner" Mode:** If you specify "Corner" in the `OffsetX` or `OffsetY` columns, the offset will be automatically calculated as half the family's width/length. This is useful for elements that are inserted by their corner, not their center.
- **Unit Recognition:** When transferring numeric parameters, the tool automatically recognizes and converts values with suffixes such as `kW`, `MW`, `W`, `V`, `kV`, `kg`.
- **Backups:** Before modifying your Excel mapping file, the tool automatically creates a full copy of it with a timestamp. The files are saved in the folder: `%AppData%\Sener\BimTools\Reports\CadToRevit\Backups\`.
- **Comments in DWG Paths:** In the tool's window, you can paste a list of paths to DWG files. Lines starting with a `;` symbol will be ignored, allowing you to temporarily disable files from processing.
- **Caution with Manual Copying:** When you copy a family instance created by this tool, you also copy its "DWG info" service parameter. This creates a duplicate link, and during the next sync, the tool will **silently update only the original instance**, ignoring all copies.
    - **Recommendation:** Do not copy elements managed by this tool. If you need a "dumb" copy, be sure to clear the value of its "DWG info" parameter to break the link.
    - *Note: In the future, this behavior is planned to be improved so that the tool itself updates the link (based on location) and reports such collisions.*
