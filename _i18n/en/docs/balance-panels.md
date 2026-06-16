# Balance Panels
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

The tool is designed to analyze the panel hierarchy and automatically redistribute circuits to minimize phase load imbalance.

## Main Features

1.  **Interactive Panel Map:** Visualization of the project's entire electrical network as a graph. Two modes are supported:
    *   **Hierarchical:** Classic "top-down" power tree.
    *   **Organic:** A physics-based model, useful for finding isolated groups or working with very large networks.
2.  **Imbalance Diagnostics:** Panel colors change depending on the percentage of phase imbalance.
3.  **Potential Indicator:** The brightness of the nodes (circles) shows how much the balance can be improved in a given panel. If the circle is dim, the balance is close to ideal for that specific set of circuits.
4.  **Smart Balancing:** The algorithm tests combinations of circuits (1P, 2P, 3P) to achieve the minimum theoretical imbalance.

![UI](image.png)

## Color Coding

Node colors depend on the configured **Thresholds** at the top left of the window:

*   **Green Zone:** Balance is within normal limits (default <5%).
*   **Yellow Zone:** Medium imbalance.
*   **Red Zone:** High imbalance, requires correction.
*   **Black Border:** The panel has high improvement potential (theoretical balance is significantly better than current).
*   **White/Grey Border:** Balance is already close to the maximum possible for the current set of loads.

## Instructions

1.  **Launch:** Click the **Balance Panels** button on the Sener panel.
2.  **Analysis:** Examine the panel tree. Use the search box (top) to quickly find a specific panel.
3.  **Selection:** Select one or more panels on the graph.
4.  **View Settings:** You can change **Hierarchical** mode, **Level Separation**, and **Node Spacing**. These changes are applied only after clicking the **Redraw** button.
5.  **Balancing:** Click the **Balance** button. The tool will attempt to automatically move slots in the panel schedule.
6.  **Results:** Upon completion, you will receive a report with "Before" and "After" imbalance metrics.
7.  **Display Modes:** Use the **Hierarchical** checkbox in settings. When enabled, the graph builds a clear tree structure from source to consumers. When disabled, the graph enters "spider web" (organic) mode, where nodes are placed more freely, which is useful for an overview of complex systems.

## Troubleshooting (Workflow)

In some cases, the Revit API does not allow the program to automatically move multi-phase circuits (2P, 3P) due to system limitations. If an error occurs during balancing:

1.  Select the problematic panel in the tool window.
2.  Click the **Open Panel Schedule View** button (table icon).
3.  In the standard Revit panel schedule view that opens, run the built-in **Rebalance loads** command.

Currently (due to the technical limitations with multi-phase panels), the tool serves as a "navigator," helping you focus only on the panels that truly require attention and can be improved.

