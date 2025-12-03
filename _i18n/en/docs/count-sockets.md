# Count Sockets
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

The **Count Sockets** command automatically counts sockets in selected electrical circuits and writes detailed information directly to circuit parameters. You get a complete specification of elements with quantities and information about their location by rooms.

## What the Command Does

- **Counts single and twin sockets** in each selected circuit
- **Groups all elements by types** with quantity indication
- **Determines element location by rooms** from the linked architectural model
- **Writes all information to circuit parameters** for use in schedules and reports

## Preparation

Before running the command, make sure that:

1. Electrical circuits to be analyzed are selected in the project
2. There is a linked architectural model with rooms (usually with the "AR01" marker in the name)
3. Parameters for recording results are created in the project: **"Sockets single"**, **"Sockets twin"**, **"ElemsDescr"**, **"LocationDescr"**

## Usage

1. **Select electrical circuits** in the model for which you need to count sockets
2. **Run the command** Count Sockets
3. **Wait for completion** — the command will show a progress bar with information about the current circuit being processed
4. **Check results** in circuit properties or create a schedule with filled parameters

## Results

The command fills the following parameters in each electrical circuit:

### Parameter "Sockets single"
Number of single sockets (integer).

*Example: 5*

### Parameter "Sockets twin"
Number of twin sockets (integer).

*Example: 3*

### Parameter "ElemsDescr"
Detailed specification of all elements in the circuit by types (multi-line text).

*Format:*
```
2: Family Name: Type Name
1: Family Name 2: Type Name 2
3: Family Name 3: Type Name 3
```

*Example:*
```
5: Socket Standard: Type A
3: Socket USB: Type B
2: Socket Twin: Type C
```

### Parameter "LocationDescr"
Information about element location by rooms with Sharjah codes (multi-line text).

*Format:*
```
quantity: room_code Room Name
quantity: room_code Room Name
quantity: None id: element_id element_id
```

*Example:*
```
5: L01-Z02-EU03-F04-005 Office
3: L01-Z02-EU03-F04-006 Corridor
2: None id: 123456 789012
```

Elements with "None" record did not fall into any room — their element IDs are indicated.

## Features

### Single and Twin Sockets Detection
The command automatically classifies sockets by the presence of keywords in the family name or element type name (case insensitive):

- **Twin sockets** — contain the word **"twin"** in the name
- **Single sockets** — contain the word **"single"** in the name
- Sockets without these words do not fall into any category and are not counted in "Sockets single" and "Sockets twin" parameters

*Examples of twin sockets:*
- Family "Socket Twin"
- Type "Twin Type A"
- Family "Standard Twin Socket"

*Examples of single sockets:*
- Family "Socket Single"
- Type "Single Type A"
- Family "Standard Single Socket"

### Sharjah Room Codes
A special code is generated for each room from five components:

**Format:** `L-Z-EU-F-S`

- **L** — Level Code
- **Z** — Zone Code
- **EU** — End-User Code
- **F** — Function Code
- **S** — Series Number

These codes are taken from room parameters in the architectural model.

### Linked Architectural Model
The command searches for rooms in linked Revit models with the **"AR01"** marker in the name. If you have a different architectural model marker, contact the developer for configuration.

### Room Detection Algorithm
For accurate room detection, the command checks the element location at several height levels (from +0.2m to -5m from the element placement point). This allows correct operation with wall-mounted sockets and elements in floors.

