# Create Security Devices — Fire, Intrusion and CCTV placement
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

The command automatically places fire alarm, intrusion (security), and CCTV (Closed-Circuit Television) devices in selected MEP spaces: ceiling detectors on a grid, wall devices (siren, manual call point, intrusion sensors), and CCTV cameras at doors and strategic points.

## What the command does

- Determines device type from the space name (see rules table)
- Computes an optimal ceiling grid using a 6300 mm coverage radius
- Detects ceiling height automatically from model geometry or uses manual input
- Places a siren above the door for spaces of type **Control** and **Celdas**
- Places a manual call point, intrusion sensor, and CCTV camera at every exterior door
- Places CCTV cameras on building corners (based on selected lines) and on existing poles
- Skips devices already placed by the command (idempotent)
- Produces a text report with detailed results by family type

## Preparation

- Device families (detectors, siren, manual call point) must be loaded into the project
- Walls, doors and ceilings may be in linked files — the command supports linked geometry
- Space names must include the keywords listed in the rules table

## Usage

1. Select one or more MEP spaces (or uncheck **Selected spaces only** to process all spaces)
2. Run the command — the settings dialog will open
3. Optionally adjust family/type names, height parameters, and worksets
4. Click **Run**

![Settings dialog](image.png)

## Placement rules

Device type is determined from a substring in the space name (case-insensitive):

| Keyword in name | Ceiling | Wall |
|---|---|---|
| **rectificador** | hidrogeno + termoelectrico | — |
| **transformador** | llamas | — |
| **bater** | optico + hidrogeno | — |
| **control** | optico + hidrogeno | siren above door |
| **celdas** | optico + termoelectrico | siren above door |
| **inversor** | — | camera in center |
| **prot civil** | — | control + expansion + keyboard + CCTV block (floor) |
| **cabinas de mt** | — | keyboard + camera in center |
| *other* | optico | — |
| *any with exterior door* | — | manual call point + intrusion sensor + CCTV |

## Settings

**Selected spaces only** — process only selected spaces.

**Auto-detect ceiling height** — the height is found by casting a ray upward from each grid point (finds nearest ceiling or roof, including linked files). When off, the height is taken from manual input.

**Manual height (mm)** — height above the space floor used in manual mode. Active only when **Auto-detect** is off.

**Family: type configuration** — family and type names for each device in the format `FamilyName: TypeName`. **Defaults** resets values to defaults.

## Algorithms

### Ceiling detectors

For each space the command builds a minimal rectangular N×M grid so that the cell half-diagonal does not exceed 6300 mm. The grid step is rounded down to 100 mm and any remainder is distributed symmetrically from the walls. If multiple detector types are required at the same grid point, they are spread along the X axis with 500 mm step.

Each point's height is taken from the nearest ceiling surface found above it (ray intersection) or from the manual height.

Spaces with complex shapes (area < 90% of bounding rectangle) are skipped and listed in the report.

### Siren above the door

A siren is placed above the door opening center at 2500 mm above the bottom of the door.

### Manual call point at the door

A manual call point is placed on the wall beside each exterior door at 1400 mm high. Preferred side is handle side; if not available (nearby door or wall end), it uses the hinge side. Orientation faces into the space.

### Volumetric sensor (Intrusion)

Placed at every exterior door at 2400 mm above floor. The algorithm attempts to find the best viewing position for the entrance:
- **2-meter priority**: the sensor is placed on the same wall at 2 m distance from the door edge and rotated 45° to the wall.
- **Handling corners**: if a wall corner is within 2 meters, the sensor is moved to the **adjacent wall** (1 meter from corner) and directed perpendicular to it.
- **Smart matching**: for each door in the room, the algorithm searches for the nearest existing similar device. If a sensor already exists (even if moved manually by the user), no second placement is performed for that door.

### Video Surveillance (CCTV)

The command supports several CCTV placement scenarios:
- **Above door**: At each exterior door (200 mm above opening, 300 mm offset from wall).
- **In space center**: For *Inversor* and *Cabinas de MT* types (height determined automatically or manually).
- **On building corners**: If **Detail Lines** representing wall boundaries are selected before running, cameras are placed at external corners (1 m offset from corner along the bisector).
- **On masts/poles**: The command finds instances of masts (Pole family specified in UI) and places cameras on them at 5 m height.

## Output

After finishing the command shows a report:
- Count of placed devices by family/type
- Count of skipped points (already occupied) with details by type (family types and IDs of existing elements)
- List of complex-shaped spaces skipped for ceiling placement

## Limitations

- Complex-shaped spaces are not processed for ceiling placement — place devices manually
- Family orientation assumes the instance front faces along -Y in the family's base orientation

