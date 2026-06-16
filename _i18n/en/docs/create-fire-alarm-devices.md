 # Create Fire Alarm Devices — Automatic placement of fire alarm devices
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

 The command automatically places fire alarm devices in selected MEP spaces: ceiling detectors on a grid and wall devices (siren, manual call point) at doors.

# Create Fire Alarm Devices — Расстановка устройств ПС

The command automatically places fire alarm devices in selected MEP spaces: ceiling detectors on a grid and wall devices (siren, manual call point) at doors.

## What the command does

- Determines device type from the space name (see rules table)
- Computes an optimal ceiling grid using a 6300 mm coverage radius
- Detects ceiling height automatically from model geometry or uses manual input
- Places a siren above the door for spaces of type **Control** and **Celdas**
- Places a manual call point at every exterior door
- Skips devices already placed by the command (idempotent)
- Produces a text report with results

## Preparation

- Device families (detectors, siren, manual call point) must be loaded into the project
- Walls, doors and ceilings may be in linked files — the command supports linked geometry
- Space names must include the keywords listed in the rules table

## Usage

1. Select one or more MEP spaces (or uncheck **Selected spaces only** to process all spaces)
2. Run the command — the settings dialog will open
3. Optionally adjust family/type names and height parameters
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
| *other* | optico | — |
| *any with exterior door* | — | manual call point |

## Settings

**Selected spaces only** — process only selected spaces.

**Auto-detect ceiling height** — the height is found by casting a ray upward from each grid point (finds nearest ceiling or roof, including linked files). When off, the height is taken from manual input.

**Manual height (mm)** — height above the space floor used in manual mode.

**Family: type configuration** — family and type names for each device in the format `FamilyName: TypeName`. **Defaults** resets values to defaults.

## Algorithms

### Ceiling detectors

For each space the command builds a minimal rectangular N×M grid so that the cell half-diagonal does not exceed 6300 mm. The grid step is rounded down to 100 mm and any remainder is distributed symmetrically from the walls. If multiple detector types are required at the same grid point, they are spread along the X axis with 500 mm step.

Each point's height is taken from the nearest ceiling surface found above it (ray intersection) or from the manual height.

Spaces with complex shapes (area < 90% of bounding rectangle) are skipped and listed in the report.

### Siren above the door

A siren is placed above the door opening center at 2500 mm above the bottom of the door. The device is offset toward the interior surface of the wall (half wall thickness + 10 mm) on the side belonging to the space so that adjacent spaces sharing the same door each receive their siren on their own side, facing into the room.

### Manual call point at the door

A manual call point is placed on the wall beside each exterior door at 1400 mm high. Preferred side is hinge side; if not available, the handle side is used. Orientation faces into the space.

## Output

After finishing the command shows a report:
- Count of placed devices by family/type
- Count of skipped points (already occupied)
- List of complex-shaped spaces skipped for ceiling placement

## Limitations

- Complex-shaped spaces are not processed for ceiling placement — place devices manually
- Family orientation assumes the instance front faces along -Y in the family's base orientation

 **Auto-detect ceiling height** — the height is found by casting a ray upward from each grid point (finds nearest ceiling or roof, including linked files). When off, the height is taken from manual input.

 **Manual height (mm)** — height above the space floor used in manual mode.

 **Family: type configuration** — family and type names for each device in the format `FamilyName: TypeName`. **Defaults** resets values to defaults.

 ## Algorithms

 ### Ceiling detectors

 For each space the command builds a minimal rectangular N×M grid so that the cell half-diagonal does not exceed 6300 mm. The grid step is rounded down to 100 mm and any remainder is distributed symmetrically from the walls. If multiple detector types are required at the same grid point, they are spread along the X axis with 500 mm step.

 Each point's height is taken from the nearest ceiling surface found above it (ray intersection) or from the manual height.

 Spaces with complex shapes (area < 90% of bounding rectangle) are skipped and listed in the report.

 ### Siren above the door

 A siren is placed above the door opening center at 2500 mm above the bottom of the door. The device is offset toward the interior surface of the wall (half wall thickness + 10 mm) on the side belonging to the space so that adjacent spaces sharing the same door each receive their siren on their own side, facing into the room.

 ### Manual call point at the door

 A manual call point is placed on the wall beside each exterior door at 1400 mm high. Preferred side is hinge side; if not available, the handle side is used. Orientation faces into the space.

 ## Output

 After finishing the command shows a report:
 - Count of placed devices by family/type
 - Count of skipped points (already occupied)
 - List of complex-shaped spaces skipped for ceiling placement

 ## Limitations

 - Complex-shaped spaces are not processed for ceiling placement — place devices manually
 - Family orientation assumes the instance front faces along -Y in the family's base orientation

