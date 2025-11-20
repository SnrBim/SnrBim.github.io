# Change Loss Method
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

This command solves the problem of bulk assigning ASHRAE codes to engineering system fittings in Revit.

## The Problem

Revit's standard interface has two significant limitations when working with ASHRAE codes:

1.  **No Batch Processing:** It's impossible to assign codes to multiple elements at once. You have to select each fitting individually and assign the code manually.
2.  **Complex Selection:** For each element, you must manually find the correct code in a long list based on its parameters (name, diameter, angle, etc.), which is time-consuming and error-prone.

![Window in two variants](pic1.gif)

## The Solution

This tool automates the process, allowing you to assign ASHRAE codes to hundreds of elements at once based on a pre-prepared table in Excel.

### How It Works

1.  **Lookup Table:** You create a table in Excel where the corresponding ASHRAE code is specified for each type of fitting (considering its name, diameter, angle, and system).
2.  **Element Selection:** You select all the necessary fittings in Revit.
3.  **Automatic Assignment:** The plugin reads the parameters of each element, finds the corresponding code for it in your Excel table, and assigns it.
4.  **Report:** Upon completion, you receive a report on which elements the codes were successfully applied to.

![Table example](pic3.png)

![Report example](pic4.png)

