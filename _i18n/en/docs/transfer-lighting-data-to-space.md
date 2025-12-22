# Transfer Lighting Data to Spaces
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

This tool transfers lighting analysis results from a **Generic Model** element to the **Space** element it is located in.

## What the Command Does
- Identifies the **Space** that contains the selected **Generic Model**.
- Copies parameter values from the source element to the target **Space**.
- Uses a configurable mapping to match source and target parameters.
- Processes multiple elements in a single operation.

## How to Use
1.  **Select Elements**: In your Revit model, select one or more **Generic Model** elements that contain the lighting calculation results. These elements are typically volumetric shapes used for analysis in software like ElumTools.
2.  **Run the Command**: Navigate to the **SNR** tab and click the **Transfer Light Data** button.
3.  **Check the Results**: The tool will automatically find the parent **Space** for each selected element and transfer the parameter values according to the configured mapping.

## Notifications and Reports
After the command finishes, a dialog box will appear with a summary of the results:
-   The number of successfully processed elements.
-   The number of elements that were skipped (e.g., if a containing space could not be found).
-   Warnings if any issues occurred during the process (e.g., a parameter was not found or is read-only).

## Parameter Mapping
The mapping between the source **Generic Model** parameters and the target **Space** parameters is configurable. This allows you to adapt the tool to different project templates or parameter naming standards.

The settings file is located at:
`%AppData%\Sener\BimTools\Settings.json`

Inside this file, find the `SNR.BimTools.TransferLightingDataToSpace.Settings` section.

**Default Mapping Example:**
```json
{
  "SNR.BimTools.TransferLightingDataToSpace.Settings": {
    "ParameterMapping": {
      "Emergency Direct Illuminance Average": "Illum em average",
      "Emergency Direct Illuminance Minimum": "Illum em minimum",
      "General Use Illuminance Average": "Illum average",
      "General Use Illuminance Minimum": "Illum minimum",
      "General Use Illuminance Maximum": "Illum maximum",
      "General Use Illuminance Minimum To Average": "Illum minimum to average",
      "General Use Illuminance Minimum To Maximum": "Illum minimum to maximum"
    }
  }
}
```
You can edit this file to add, remove, or change the "source parameter": "target parameter" pairs.

