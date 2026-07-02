@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Remove-SmallPictures.ps1" %*
