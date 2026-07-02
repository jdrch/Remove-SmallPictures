# `Remove-SmallPictures`

## Disclaimer

This script was written by Copilot Premium in response to the following prompt:

> Write a PowerShell script that deletes all pictures from the current working folder that meet the following criteria: 1) Height less than 2160 pixels OR 2) Width less than 3840 pixels

## Description

A PowerShell script that deletes images of height < 2160p and width < 3840p from the current working directory.

## How it works

* Image detection: The script checks common image extensions (`.jpg`, `.jpeg`, `.png`, `.tif`, `.tiff`, `.bmp`, `.gif`, `.webp`).
* Dimension check: For each image it reads Width and Height using System.Drawing.Image.
* Deletion rule: Deletes when Height < 2160 OR Width < 3840.
* Safety: The script is an advanced function `([CmdletBinding(SupportsShouldProcess = $true)])` so you can run it with `-WhatIf` to preview deletions or `-Confirm` to be prompted for each file.
* Resource handling: Images are disposed after reading to avoid file locks.
* Optional recursion: Use `-Recurse` to include subfolders.

# Usage examples

* Preview deletions in current folder
```
.\Remove-SmallPictures.ps1 -WhatIf
```
* Delete only in current folder (no recursion)
```
.\Remove-SmallPictures.ps1
```
* Delete including subfolders
```
.\Remove-SmallPictures.ps1 -Recurse
```
* Run with confirmation prompts
```
.\Remove-SmallPictures.ps1 -Confirm
```

# Installation

Download both `.ps1` and `.cmd` scripts to the same folder.
