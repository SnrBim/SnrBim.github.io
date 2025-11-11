# Assign Circuit to Conduits
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

This tool is designed to add circuit information to the properties of electrical conduits. The user selects a circuit and the corresponding conduits, and the algorithm automatically updates their parameters, adding the circuit information to the `SRS_MEP_Circuit_Names` parameter.

Before this, if the circuit name is empty, the algorithm generates it automatically from the `SRS_Schedule_Name` parameter values of the load and the electrical panel. This tool is used for the subsequent execution of **SyncConduitCircuit**.

## Required Data

Before running the command, ensure that the load, electrical panel, and intermediate distribution boxes have names in the `SRS_Schedule_Name` parameter. Otherwise, their IDs will be used.

## Instructions for Use

1.  **Select Elements:**
    -   Select a load family associated with a circuit.
    -   If the load belongs to multiple circuits, select the desired circuit using the **Tab** key.
    -   Select one or more electrical conduits.

2.  **Run the Tool:**
    -   Upon launch, the algorithm will automatically validate the selection.
    -   An error message will appear if multiple circuits are selected. If no conduits are selected, an **auxiliary mode** is activated: the plugin will identify the conduits belonging to the circuit, and the execution will stop.

3.  **Automatic Circuit Name Assignment:**
    -   If the circuit already has a name, it will be used.
    -   If the name is empty, it will be generated automatically based on the `SRS_Schedule_Name` parameters of the load and panel, following the format: `18D-[Panel]/[Load]-C-SystemNumber`.
    -   The following table details how load names are grouped to generate the segment name:
        | Input Data                                  | Resulting Load Name            | Comment                                                     |
        | ------------------------------------------- | ------------------------------ | ----------------------------------------------------------- |
        | `18D-DS-SF01`                               | `18D-DS-SF01`                  | A single name remains the same.                             |
        | `18D-DS-SF01`, `18D-DS-SF02`, `18D-DS-SF03` | `18D-DS-SFxx`                  | Names with the same base are grouped with `xx` at the end.  |
        | `18D-DS-SF01`, `18D-DS-XY02`                | `18D-DS-SF01, 18D-DS-XY02`     | Heterogeneous names are listed separated by commas.         |
        | `"" (ID: 12345)`, `18D-DS-SF01`             | `12345, 18D-DS-SF01`           | If there is no name, the element's ID is used.              |

4.  **Add Information to Conduits:**
    -   The `SRS_MEP_Circuit_Names` parameter will be updated in all selected conduits, adding the new circuit name in alphabetical order without deleting previous data.

5.  **Notification:**
    -   Upon completion, a notification will confirm the operation and indicate how many different circuits are now associated with each conduit.

![image](https://github.com/user-attachments/assets/27ea5b1c-fa1b-4901-8c08-8274da4ae6da)

![image](https://github.com/user-attachments/assets/abfc75f0-f174-4e89-8dc2-eb8db904fda4)
