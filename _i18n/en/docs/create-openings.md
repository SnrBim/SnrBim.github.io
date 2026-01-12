# Create Openings
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

<img src="Logo.png" alt="Logo" style="float:right; margin:0 15px 15px 0;" width="48"/> The command automates the process of creating and updating openings in walls for the passage of MEP elements. It analyzes intersections, considers existing openings, merges closely located new openings, and generates a detailed report on the actions performed.

---

### What the Command Does

*   **Finds intersections** between walls and MEP elements (ducts, pipes, cable trays, etc.) in both the current project and linked models.
*   **Manages existing openings**: Instead of creating duplicates, the command can expand or merge openings that already exist in the wall.
*   **Automatically merges** closely located calculated openings into a single common one to avoid numerous small holes.
*   **Writes the final dimensions** of all openings into a specified wall parameter as a numbered list.
*   **Is flexibly configured** through a dialog box, allowing the user to control all key parameters.
*   **Creates a detailed report** of all actions performed (creation, modification, deletion) and displays it in an interactive window.

![Window](image.png)

### Preparation

Before running the command, ensure that your 3D view is set up to show all the walls and MEP elements you want to process.

### Usage

When the command is launched, a settings dialog box opens.

1.  **Wall Selection**:
    *   **Process selected walls only**: If this checkbox is marked, the command will only work with the walls you selected before launching. Otherwise, all walls in the project will be processed.
    *   The **OK** button dynamically displays the number of walls that will be processed.

2.  **MEP Category Selection**:
    *   Mark the checkboxes for the MEP system categories for which openings need to be created.

3.  **Opening Parameters**:
    *   **Air gap (mm)**: A buffer added to the dimensions of each MEP element. This increases the final size of the opening. *Default: 30 mm.*
    *   **Merge threshold (mm)**: The maximum width of a wall section between openings. If the gap between the edges of two adjacent openings is less than this value, they will be merged into one. *Default: 100 mm.*
    *   **Info Parameter**: The name of the text parameter in the wall where the final list of all opening sizes will be written. *Default: Comments.*

4.  **Filtering and Rounding**:
    *   **Min MEP element size (mm)**: MEP elements whose largest dimension is smaller than the specified value will be ignored. Useful for filtering out small elements. *Default: 0.*
    *   **Rounding step (mm)**: Rounds the final width and height of the opening to a multiple of the specified number. *Default: 10.*
        *   **Up** (checkbox enabled): Rounds up to the nearest greater multiple (e.g., 405 -> 410).
        *   **Nearest** (checkbox disabled): Mathematical rounding (e.g., 405 -> 400).
    *   **Visualize Bounding Box for debugging**: Creates geometry in the model showing the bounding boxes of MEP elements. **Warning:** This geometry is not automatically deleted. Use this option for debugging only and delete the created elements manually to avoid cluttering the project.

5.  **Ignore by Parameter**:
    *   Allows setting rules to filter MEP elements. Elements that satisfy at least one rule will be ignored. **Parameter names** are case-sensitive, while **values** are not.
    *   **Format**: Each rule on a new line: `ParameterName: Value`.
    *   **Wildcard**: You can use the `*` symbol to match any sequence of characters.
    *   **Pseudo-parameters**: `Family` (family name) and `Type` (type name) are supported.
    *   **Comments**: Lines starting with `;` are ignored.
    *   **Example**:
        ```
        ; Ignore all elements on worksets containing "placeholder"
        Workset: *placeholder*
        ; Ignore elements with a specific comment
        Comment: *ignore*
        ```

### Results

After performing the calculations, the command displays an interactive report with the results, creates/modifies/deletes openings in the Revit model, and writes the final information to the walls.

**Writing to Wall Parameter:**
A numbered list of the final sizes (WxH) of all openings in a given wall is written to the text parameter specified in the settings.
*Example:*
```
1. 630x480
2. 280x330
3. 70x70
```
If there are no openings in the wall after processing, the parameter is cleared. When processing only selected walls, the parameters of unprocessed walls are not changed. This parameter is useful for creating view filters to display only those walls that have openings (by setting up a filter rule for "parameter is not empty").

**Report Format:**
The report contains lines for each action in the format: `Action | Wall ID | Opening ID | Description`

The `Description` column has a 5-part structure:
`Old ID | New Size (WxH) | Old Size (WxH) | Source (MEP ID) | Merge Info`

*   **CREATED**: A new opening was created.
    *   *Example: `CREATED | w777 | op888 | | 500x300 | | MEP_IDs: main:1,2 |`*
*   **MODIFIED**: An existing opening was modified.
    *   *Example: `MODIFIED | w778 | op999 | 123 | 600x400 | 500x300 | MEP_IDs: link:3 | Merged with: 456`*
*   **DELETED**: An existing opening was deleted because it was merged with another.
    *   *Example: `DELETED | w779 | op456 | | | | | Merged into: 999`*
