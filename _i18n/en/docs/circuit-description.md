# Circuit Description
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

The **Circuit description** command automatically generates uniform and informative descriptions for electrical circuits based on connected equipment and their location. The description is formed with equipment types, quantities, and room numbers where they are installed.

## Usage

1. **Open an electrical panel schedule** (Panel Schedule) in Revit
   - You can select multiple schedules in the project browser for batch processing
2. **Run the command** Circuit description
3. **Wait for completion** — the command will process all circuits of the selected panels
4. **Check the results** in the Load Name parameter of each circuit
5. **Open the report** — click on the notification to view a detailed report in Excel

## Description Format

Circuit description is formed in the following format:

```
Equipment Code × Quantity, Code2 × Quantity | Room Number × Quantity, Room2 × Quantity
```

### Examples

**Example 1:** Circuit with lighting and receptacles in different rooms
```
LTG × 4, RECPT × 2 | 101 × 3, 102 × 3
```
*Explanation:* The circuit has 4 lighting fixtures (LTG) and 2 receptacles (RECPT) connected. Of these, 3 elements are installed in room 101, and 3 elements in room 102.

**Example 2:** Circuit with receptacles only in one room
```
RECPT × 5 | 201
```
*Explanation:* The circuit has 5 receptacles, all in room 201. The quantity "× 1" is automatically simplified.

**Example 3:** Circuit with electrical equipment
```
AHU-01 × 2 | 305 × 2
```
*Explanation:* The circuit has 2 AHU-01 equipment units connected, both in room 305.

**Example 4:** Circuit with numbered lighting fixtures
```
LTG-01, LTG-02, LTG-03 | 101 × 3
```
*Explanation:* The circuit has three numbered lighting fixtures in room 101.

## Equipment Code Logic

The command automatically determines the code for each element in the circuit based on its category and parameters:

### Electrical Equipment
The code is taken from the **`SRS_Schedule_Name`** parameter

*Examples:* `AHU-01`, `FCU-02`, `PUMP-03`

### Lighting Fixtures
1. First, the **`SRS_MEP_Equipment_Code`** parameter is checked (instance, then type)
2. If the **`SRS_Equipment_Number`** parameter is found, it's added to the code with a hyphen
3. If no code is found, the standard designation **`LTG`** is used

*Examples:* `LTG`, `LTG-01`, `LTG-02`

### Electrical Fixtures
1. The code is taken from the **`SRS_MEP_Equipment_Code`** parameter (instance, then type)
2. If the **`SRS_Equipment_Number`** parameter is found, it's added to the code with a hyphen
3. If no code is found, **`?`** is used

*Examples:* `PANEL-01`, `DIST-02`

### Other Categories
For all other categories (receptacles, switches, etc.), the standard designation **`RECPT`** is used

*RECPT = receptacle*

## Location Determination

The command determines the room number for each element in the following order:

1. **MEP Spaces** — primary method. The command checks if the element's placement point is inside an MEP space
2. **Location Parameter** — if the element is not in any MEP space, the standard Revit location parameter is used
3. **"?" Symbol** — if the location cannot be determined

### Room Detection Features

- The command uses an optimized algorithm with caching for fast processing of large numbers of elements
- For elements from the same circuit, frequently used rooms are checked first
- The command can use previously manually created descriptions to clarify the location of elements with undefined locations

## Report

After processing, a detailed Excel report is created with the following information:

- **Panel** — electrical panel name
- **PanelId** — panel ID in Revit
- **Circuit** — circuit name
- **CircuitId** — circuit ID in Revit
- **OldDescription** — previous circuit description
- **NewDescription** — new generated description (or "=" if description hasn't changed)

The report is saved in the folder:
```
%APPDATA%\Sener\BimTools\Reports\GenCircuitDescription\
```

## Tips

- **Batch Processing**: Select multiple panel schedules in the project browser before running the command for simultaneous processing
- **Re-run**: The command can be run repeatedly — it will update descriptions based on the current model state
- **Report Review**: Pay attention to rows with "=" in the report — these are circuits that already had the correct description
- **Undefined Elements**: If "?" symbols appear in the description, check for MEP Spaces in the model and correct element placement

![alt text](pic1.png)
![alt text](pic2.png)

