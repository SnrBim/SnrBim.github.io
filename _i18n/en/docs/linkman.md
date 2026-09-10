# Link manager
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

Link manager helps you update Revit and AutoCAD links by selecting a folder for file search and lets you review link information.

![LinkMan interface](ui.png)

## Searching and updating links

1. Click **Select folder...** and choose a search folder. LinkMan searches it and its subfolders, matching files to project links by file name. It checks the selected folder first, then nested folders level by level; folders at the same level are checked in reverse natural order.
2. After a match is found, the row is selected automatically if the new path differs from the current path and the link is available for editing. A matching path or a link owned by another user is not selected automatically, but you can select it manually. Check the new path, file size, and modified date.
3. You can choose a new file with the individual button in the row or paste its path into **Found path**. **Current path** is available only for viewing and copying. **Found path** accepts absolute and relative paths; a relative path is resolved from the folder containing the current link.
4. The label to the left of **Update** shows the selected links split between new and current paths. The button itself shows the number of selected links by type: CAD and RVT.

> A progress window is shown during the update. Clicking the cancel button does not interrupt the update already in progress, but the next link will not be processed.

## Important limitations

Updating or deleting Revit links clears the operation history, so `Ctrl+Z` cannot undo the action. Updating AutoCAD links does not have this limitation.

## Revit warning handling

During the update, LinkMan automatically confirms selected standard Revit warnings that do not require user input, such as messages about geometry exceeding allowed extents or elements being lost during import. If Revit shows a warning about deleting dimensions, LinkMan presses the **Delete Dimension(s)** button in the Revit dialog because there is no other way to continue the update. Other dialogs are not suppressed and remain available for the user to review.

![Invalid references warning](invalidRefs.png) ![Extents warning](33km.png)

> The list of handled warnings is incomplete. If an unhandled Revit dialog appears, send its screenshot to the tool author so the warning can be added to the automatic handling.

## Viewing and display

- The **Instances** column shows the number of link instances. Hover over the value to see a tooltip with details. Right-click the value to copy the data to the clipboard.
- **Narrow view** combines the current and new path, size, and date into compact two-line cells. It is useful for long paths and comparing the old and new files; in the regular view, the new file information is shown in separate columns.
- **Right alignment** aligns paths to the right, making it easier to compare file names without their directories.

## Deleting links

Right-click a link row to delete it; multiple links can be selected. LinkMan asks for confirmation and shows the selected items. Deleting removes the link types and all their instances from the current project, but does not delete the source files from disk.

