@echo off

REM =================================
if [%1]==[] %~dp0\..\getadmin.bat "%~dp0\%~nx0"

REM =================================

powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin

REM =================================

choco feature enable -nautoUninstaller

REM Everything 
REM GoogleChrome 
REM notepadplusplus 
REM 7zip 

cinst -y cmder f.lux git potplayer putty python2 teamviewer kodi

cd/d d:\Users\sita\Documents
git clone https://github.com/chsliu/batch.git

mkdir %appdata%\Kodi
cd/d %appdata%\Kodi
git clone https://github.com/chsliu/userdata.git

rem pause

C:\Windows\System32\timeout.exe 10
