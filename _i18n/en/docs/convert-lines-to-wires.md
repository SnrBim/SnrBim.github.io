# Line to Wires
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

The **Line to Wires** command allows you to quickly convert ordinary detail lines into electrical wires in an Autodesk Revit project. It analyzes the selected lines, finds nearby electrical devices (such as lighting fixtures, equipment, and outlets), determines their connectors, and automatically creates wires connecting them.

![image](.\pic1.png)

## How to Use

1.  Draw detail lines in your Revit view to represent the path of the electrical wires.
2.  Run the **Line to Wires** command from the BIM Tools panel.
3.  The command will automatically detect the lines and nearby electrical devices.
4.  Adjust the settings in the dialog window if necessary.
5.  Click "OK" to create the wires. The original lines will be deleted by default.

## Features and Settings

### Operating Modes

-   **Delete input lines**: (Default: Enabled) Deletes the original detail lines after the wires are created.
-   **Auto split by devices**: (Default: Enabled) Automatically splits a single line into multiple wire segments where it intersects with electrical devices. This allows you to draw one continuous line across multiple devices.
-   **Shift mode**: (Default: Disabled) If a line's endpoint is exactly at a device connector, it will be shifted by 1 mm to prevent potential errors.
-   **Silent mode**: (Default: Disabled) If you pre-select lines in the model before running the command, it will execute immediately using the last saved settings, without showing the dialog window.

### Settings

-   **Search threshold**: (Default: 30 mm) The radius around the lines and their endpoints within which the command will search for electrical devices to connect to.
-   **Auto split max distance**: (Default: 1000 mm) An additional check for the maximum distance from a line to a device's connector, which is particularly useful for diagonal lines.

### Mappings

#### Line Style to Wire Type Mapping

You can map specific line styles to corresponding wire types. If a mapping is not provided, the command will try to match the wire type by the line style's name or use the project's default wire type.

**Format:**
`LineStyleName: WireTypeName`

*Use a semicolon `;` at the beginning of a line to comment it out.*

**Example:**
```
DASHED_LINE: Wire-PVC-1.5
SOLID_LINE: Wire-PVC-2.5
```

#### Connector Mapping

For device families with multiple connectors, you can specify which connector index the wire should connect to.

**Format:**
`FamilyName: TypeName: ConnectorIndex`

*The `ConnectorIndex` is a zero-based integer.*

**Example:**
```
GenericOutlet: Duplex: 0
SpecificFixture: Model-A: 1
```
