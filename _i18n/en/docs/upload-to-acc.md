# UploadToAcc - User Guide
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

## Description

The **UploadToAcc** command uploads local Revit models to Autodesk Construction Cloud (ACC) in batches, without requiring you to open each model manually.

## How to Get the Required URLs from ACC

To upload models, provide two URLs from the ACC web interface:

### 1. Account + Project URL

**Steps:**

1. Open https://acc.autodesk.com/insight in your browser
   - You will be automatically redirected to one of your projects

2. Find the project selection drop-down menu at the top of the page

3. Select the required project

4. Copy the URL from the browser address bar

**URL format:**
```
https://acc.autodesk.com/insight/accounts/{accountId}/projects/{projectId}/my-dashboard
https://acc.autodesk.com/insight/accounts/11111111-1111-1111-1111-111111111111/projects/22222222-2222-2222-2222-222222222222/my-dashboard

```
![How the project selection menu looks](image.png)

### 2. Project + Folder URL

**Steps:**

1. In the same project, switch from **Insight** to **Docs**
   - Use the switcher in the upper-left corner of the page

2. The project file structure will open

3. Navigate to the folder where you want to upload the models

4. Copy the URL from the browser address bar

**URL format:**
```
https://acc.autodesk.com/docs/files/projects/{projectId}?folderUrn={folderId}
https://acc.autodesk.com/docs/files/projects/22222222-2222-2222-2222-222222222222?folderUrn={folderId}
```
![How the switch from Insight to Docs looks](image-1.png)

## Upload Process

1. **Select files**
   - Click the "Select files..." button
   - Select one or more `.rvt` files

2. **Enter URLs**
   - Paste the first URL (Account + Project) into the "Account + Project URL" field
   - Paste the second URL (Project + Folder) into the "Project + Folder URL" field

3. **Label (optional)**
   - A unique name for this URL pair is generated automatically
   - You can change it to make it easier to recognize. The recommended format is ShortProjectName FolderName.
   - Use the "History..." button to select previously used URLs

4. **Upload**
   - Click the "Upload" button
   - Progress and elapsed time will be shown for each file
   - A results dialog will appear when the process is complete

## Important Notes

- **Worksharing:** If the model is not workshared, the tool will enable this feature automatically before uploading
- **Upload time:** Please be patient - even an empty project (300 KB) takes 20-30 seconds to upload. Real models may take considerably longer.
- **History:** URL pairs are automatically saved to history for reuse
- **Cancellation:** The process can be cancelled with the "Cancel" button in the progress bar. The current file will finish uploading, but subsequent files will not be processed.

## Troubleshooting

If errors occur:

1. Make sure you are signed in to your account in Revit
2. Check that the URLs were copied in full, without truncation
3. Use the "Open Log" button to view detailed logs
4. Make sure you have permission to upload to the selected project folder
5. Make sure the files are not links in currently open documents

