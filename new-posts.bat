@echo off
setlocal
echo For Posts, press 1
echo For Projects, press 2
CHOICE /c:12 /n /m Choice:
if %errorlevel% EQU 2 set category=projects
if %errorlevel% EQU 1 set category=post
:Naming
cls
echo Selected: %category%
echo Type the name of the new post
echo Use dash for spacing
set Name=
set /p Name=Name:
if NOT defined Name goto Naming
hugo new content\%category%\%Name%.md
exit