@echo off
setlocal
echo For Posts, press 1
echo For Projects, press 2
CHOICE /c:12 /n /m Choice:
if %errorlevel% EQU 2 set post=projects
if %errorlevel% EQU 1 set post=posts
:Naming
cls
echo Selected: %post%
echo Type the name of the new post
echo Use dash for spacing
set Name=
set /p Name=Name:
if NOT defined Name goto Naming
hugo new content\%post%\%Name%.md
exit