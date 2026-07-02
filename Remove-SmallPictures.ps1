<#
 .DISCLAIMER 
 
  Copilot Premium wrote this function from the following prompt: 

  Write a PowerShell script that deletes all pictures from the current working folder that meet the following criteria: 1) Height less than 2160 pixels OR 2) Width less than 3840 pixels
 
.SYNOPSIS
  Delete images smaller than 3840x2160 (width x height) from the current folder.

.DESCRIPTION
  Scans common image files in the current working folder (optionally recursively).
  Deletes files where Height < 2160 OR Width < 3840.
  Supports -WhatIf and -Confirm via CmdletBinding.

.EXAMPLE
  # Preview deletions in current folder
  .\Remove-SmallPictures.ps1 -WhatIf

  # Actually delete in current folder and subfolders
  .\Remove-SmallPictures.ps1 -Recurse
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [switch] $Recurse
)

# Extensions to check
$extPattern = '^(?:\.jpg|\.jpeg|\.png|\.tif|\.tiff|\.bmp|\.gif\.webp)$'

# Counters
$deleted = 0
$skipped = 0
$errors = 0

# Load System.Drawing (works on Windows PowerShell and many PowerShell 7 installs)
try {
    Add-Type -AssemblyName System.Drawing -ErrorAction Stop
} catch {
    Write-Verbose "Could not load System.Drawing assembly: $_"
    Write-Warning "System.Drawing could not be loaded. This script requires System.Drawing to read image dimensions."
    return
}

# Get files
$files = Get-ChildItem -File -ErrorAction Stop -Force -Recurse:$Recurse | Where-Object { $_.Extension -match $extPattern }

if (-not $files) {
    Write-Output "No image files found in '$(Get-Location)'."
    return
}

foreach ($file in $files) {
    try {
        $img = [System.Drawing.Image]::FromFile($file.FullName)
    } catch {
        Write-Warning "Unable to open image: $($file.Name) — $_"
        $errors++
        continue
    }

    try {
        $width = $img.Width
        $height = $img.Height
    } finally {
        if ($img) { $img.Dispose() }
    }

    if ($height -lt 2160 -or $width -lt 3840) {
        $message = "Remove file $($file.FullName) (Width=$width, Height=$height)"
        if ($PSCmdlet.ShouldProcess($file.FullName, "Remove image smaller than 3840x2160")) {
            try {
                Remove-Item -LiteralPath $file.FullName -Force -ErrorAction Stop
                Write-Verbose "Deleted: $($file.FullName)"
                $deleted++
            } catch {
                Write-Warning "Failed to delete $($file.FullName): $_"
                $errors++
            }
        } else {
            # If ShouldProcess returned false (e.g., -WhatIf), count as skipped preview
            $skipped++
        }
    } else {
        Write-Verbose "Kept: $($file.Name) (Width=$width, Height=$height)"
    }
}

# Summary
Write-Output "Summary:"
Write-Output "  Files deleted: $deleted"
Write-Output "  Files skipped (preview or not matching removal): $skipped"
Write-Output "  Errors: $errors"
