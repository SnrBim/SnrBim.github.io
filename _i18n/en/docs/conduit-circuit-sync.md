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

Before running the command, ensure that at least one conduit in each segment has a circuit name in `SRS_MEP_Circuit_Names` and that a circuit with the same name exists. It is recommended to use **AssignConduitToCircuit** for this purpose.

## Algorithm Description

1.  **Parameter Unification:** Prepares equipment names in the `SRS_Schedule_Name` parameter by concatenating `SRS_Location`, `SRS_Equipment_Type`, and `SRS_Equipment_Number`.
2.  **Search:** Finds all conduits and circuits where the `SRS_MEP_Circuit_Names` parameter is defined.
3.  **Section Identification:** Detects groups of interconnected conduits (chains) based on physical connection and the shared value in `SRS_MEP_Circuit_Names`.
4.  **Grouping by Circuit:** Associates conduit chains with their respective electrical circuits.
5.  **Direction Determination:** Sorts the conduits in the path from the load to the electrical panel.
6.  **Segment Division:** The path is divided into segments between distribution boxes (a gap of up to 10 cm is allowed). The process stops with an error if there are more than 5 segments.
7.  **Segment Naming:** Each segment is assigned a unique name with the format `18D-[Panel]/[Load]-CC-SystemNumber`. The rules for forming the load name are as follows:
    | Input Data                                  | Resulting Load Name            | Comment                                                     |
    | ------------------------------------------- | ------------------------------ | ----------------------------------------------------------- |
    | `18D-DS-SF01`                               | `18D-DS-SF01`                  | A single name remains the same.                             |
    | `18D-DS-SF01`, `18D-DS-SF02`, `18D-DS-SF03` | `18D-DS-SFxx`                  | Names with the same base are grouped with `xx` at the end.  |
    | `18D-DS-SF01`, `18D-DS-XY02`                | `18D-DS-SF01, 18D-DS-XY02`     | Heterogeneous names are listed separated by commas.         |
    | `"" (ID: 12345)`, `18D-DS-SF01`             | `12345, 18D-DS-SF01`           | If there is no name, the element's ID is used.              |
8.  **Data Recording:**
    -   Updates `SRS_MEP_Circuit_Names` in all conduits of the segment.
    -   Fills in `SRS_MEP_Conduit_From`, `SRS_MEP_Conduit_To`, and `SRS_MEP_Conduit_Tag` in the conduits.
    -   Stores segment names in the electrical circuit's `SRS_MEP_Conduit_Segment_1` to `SRS_MEP_Conduit_Segment_5` parameters.
9.  **Notification:** Confirms the operation and reports suspicious distances (>1m) between segments to detect potential assignment errors.

![image](https://github.com/user-attachments/assets/9a9058a0-1832-4f33-b80b-af01cc471fc6)


