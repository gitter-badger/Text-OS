@echo off
title Text OS
setlocal enabledelayedexpansion


:: Want to see all the TextOS-Specefic commands? do "set TextOS" in the devprompt
set TextOS.Version=0.1.059
set TextOS.StandardTitle=Text OS ^| Version: !TextOS.Version!
set TextOS.BootedFromTextOS=1
set TextOS.RandomNumber=%random%
set TextOS.UseBooterMsg=Make sure you boot from the booter.
set TextOS.MM=Error loading TextOS.BootedFromTextOS. Having this not set may crash Text-OS programs.
set TextOS.SkipLoad=true
set TextOS.Unrandomize=false
set TextOS.DoEchoOn=false
set TextOS.RestartButSkipVariablesCmd=goto RBSVC
set TextOS.HomeFolder=%cd%\data\homefolder
cd Data

:: Errors
if not defined BIOS_ram echo Error loading RAM. !UseBooterMsg! && pause >nul && exit
if not defined BIOS_version echo Error loading BIOS version. !UseBooterMsg! && pause >nul && exit
if not defined TextOS.BootedFromTextOS echo !TextOS.MM! && pause >nul && exit
if not exist cmdmenusel.exe echo Error loading cmdmenusel.exe. && pause >nul && exit

title !TextOS.StandardTitle!
if !TextOS.SkipLoad! == true goto menu
:Load
cls
echo Loading... 
!Timeout! 2 >nul

:: This is where the !TextOS.RestartButSkipVariablesCmd! Command from the dev prompt puts you, ignoring error check and variable setting.
:RBSVC

:menu
:: the variable !username! uses your account name, for example, for me the variable is Rasmusolle because my win acc name is Rasmusolle.
cls
echo ===============TEXT=OS=MENU==============
echo.
echo Hello !username!. Welcome to the Text-OS menu.
echo You are running Text-OS !TextOS.Version!
echo.
!Selection! "Command Prompt" "Programs" "Games" "Home Directory" "Exit"

if %errorlevel% == 1 goto precmd
if %errorlevel% == 2 goto Programs
if %errorlevel% == 3 goto Games
if %errorlevel% == 4 goto HomeDirectory
if %errorlevel% == 5 goto cmd
goto menu

:: ====================Programs====================

:Programs
cls
echo ===============PROGRAMS==============
echo.
!Selection! "Calculator" "Back To Menu"

if %errorlevel% == 1 goto Calc
if %errorlevel% == 2 goto menu
goto Programs

:: j�ke

:Calc
cls
cd Programs
cd Calculator
set TextOS.FileToExecute=Calculator.bat
if not exist !TextOS.FileToExecute! goto NotFound
call !TextOS.FileToExecute!
title !TextOS.Standardtitle!
cd.. && cd..
goto menu

:: ====================Programs=End===================


:: ====================Games===================

:Games
cls
echo ===============GAMES=(WIP)==============
echo.
!Selection! "Guess The Number" "Back To Menu"

if %errorlevel% == 1 goto GuessTheNumber
if %errorlevel% == 2 goto menu
goto menu

:GuessTheNumber
cls
cd Games
cd GuessTheNumber
set TextOS.FileToExecute=GuessTheNumber.bat
if not exist !TextOS.FileToExecute! goto NotFound
call !TextOS.FileToExecute!
title !TextOS.StandardTitle!
cd.. && cd..
goto menu

:: ====================Games End====================

:: Generic errors for games and programs

:VarError
cls
echo Could not read the variable TextOS.FileToExecute. Setting TextOS.FileToExecute variable.
set TextOS.FileToExecute=1
pause >nul
goto menu

:NotFound
cls
echo File !file! not found.
pause >nul
goto menu

:: ====================Text=OS=Command=Prompt====================

:precmd
cls
echo ====Text=OS=Command=Prompt====
echo.
echo Type help for a list of commands.
echo.
:cmd
set/p TextOS.CmdPromptInput=^>

if !TextOS.CmdPromptInput! == help echo Coming soon!
if !TextOS.CmdPromptInput! == ver goto ver
if !TextOS.CmdPromptInput! == version goto ver
if !TextOS.CmdPromptInput! == echo goto echo
if !TextOS.CmdPromptInput! == dir dir
if !TextOS.CmdPromptInput! == dir/w dir/w
if !TextOS.CmdPromptInput! == cls cls
if !TextOS.CmdPromptInput! == secret goto DevPromptStart
if !TextOS.CmdPromptInput! == vdisk goto MountVirtualDisk
goto cmd

:help
echo.
echo This is a list of all commands.
echo.
echo ver/version - Shows TextOS and BIOS version 
echo echo - echo mode
echo dir - Shows the current directory
echo dir/w - Shows a compressed version of the current directory
echo cls - Clears the screen
echo vdisk - Virtual Disk
goto cmd

:ver
echo.
echo Text OS version: !Version!
echo BIOS version: !BIOS_version!
goto cmd

:echo
set /a echo_mode+=1
echo.
echo You are in echo mode.
set/p ECHO_INPUT=Enter: 
goto cmd

:loadprogram
echo.
echo You are in LoadProgram mode.
set/p TextOS.LoadProgramInput=Enter filename (put it in the "Data" folder, and exluding file extension):
echo.
if not exist !TextOS.LoadProgramInput!.bat echo Could not find the file. && !Timeout! 4 >nul && goto loadprogram
call !TextOS.LoadProgramInput!
goto menu

:MountVirtualDisk
cd VirtualDrives
set /p TextOS.LatestVirtualDriveInput=Enter letter (ONLY THE LETTER): 
set TextOS.MountedDrive=!TextOS.LatestVirtualDriveInput!
if not exist !TextOS.MountedDrive! mkdir !TextOS.MountedDrive!
cd !TextOS.MountedDrive!
echo Mounted.
cls

:VDiskModeMsg
echo You are in VDisk mode.
echo.
:VDiskMode
if !TextOS.VDisk_ReadC! == 1 echo. && set TextOS.VDisk_ReadC=0
set/p TextOS.VDiskModeInput=!TextOS.MountedDrive!:\
if !TextOS.VDiskModeInput! == back cd.. && cd.. && goto menu
if !TextOS.VDiskModeInput! == dir dir
if !TextOS.VDiskModeInput! == read goto VDisk_Read
if exist !TextOS.VDiskModeInput! "!TextOS.VDiskModeInput!"
goto VDiskMode

:VDisk_Read
set/p TextOS.VDisk_ReadInput=Enter file to read (with file extension):
if not exist !TextOS.VDisk_ReadInput! call :VDisk_404 && goto VDisk_Read

type !TextOS.VDisk_ReadInput!
set TextOS.VDisk_ReadC=1
goto VDiskMode

:VDisk_404
echo Could not find file. Please try again
pause >nul
exit /b

:: ====================Text=OS=Command=Prompt=End===================

:HomeDirectory
cls
echo This is coming soon.
pause >nul
goto menu


:DevPromptStart
cls
echo Type info for info
:DevPrompt
set/p c=%cd%^>
if !TextOS.LatestDevPromptInput! == info goto DevInfo
%c%
goto DevPrompt

:DevInfo
echo      This is a tool for developers to execute code through a prompt or to check variables.
echo      To go back to TextOS, type ^^!TextOS.RestartButSkipVariablesCmd^^!
goto DevPrompt

:: Random lines of code to increase file size:
:: fgjdklgjdlfjrgkljglfjgkldfjgkldjgdklgjdfjkdgjdklgjdfgjkdfkgjdfjklgdklgjdkfgjljafgkldfjgdkgjawfbayhg
:: sdghdjkghdfjkghdjkghdfkjghdfghjkghjkghdkjsdjriwoerisdfks�dfklgjdfkgljdkfgjdkfgjdfngdfkgdfjgkdjfgkjd
:: sdfjsdkgjdrighgjkghdfkghdjkghdjkghdjkghjdkgkhditueruiteioskldruidkrukudrudrdurunsdkdfgjkfgdkdkdjhhh
:: dfkgjdkfgdjkgjdfgjdjhidgjlkdgjdfjglyoudfjkfhgfhdfjkhavedjkhsdfhsdkjdjhsdhjksdjsdfhsdkfhsdfshdfksdhh
:: kxfgljdfgkjdfgkldgjdfgjdfkgjdfgjkgjdfgdgjljdfkgjdfjxxjkxjkxjksdnvnkdngkgkdbgkbnrlebfksbngldbfkrbdih
:: sdghdjkghdfjkghdjkghdfkjghdfghjkghjkghdkjsdjriwoerisdfks�dfklgjdfkgljdkfgjdkfgjdfngdfkgdfjgkdjfgkjd
:: sdfjsdkgjdrighgjkghdfkghdjkghdjkghdjkghjdkgkhditueruiteioskldruidkrukudrudrdurunsdkdfgjkfgdkdkdjhhh
:: dfkgjdkfgdjkgjdfgjdjhidgjlkdgjdfjglyoudfjkfhgfhdfjkhavedjkhsdfhsdkjdjhsdhjksdjsdfhsdkfhsdfshdfksdhh
:: kxfgljdfgkjdfgkldgjdfgjdfkgjdfgjkgjdfgdgjljdfkgjdfjxxjkxjkxjksdnvnkdngkgkdbgkbnrlebfksbngldbfkrbdih
:: fgjdklgjdlfjrgkljglfjgkldfjgkldjgdklgjdfjkdgjdklgjdfgjkdfkgjdfjklgdklgjdkfgjljafgkldfjgdkgjawfbayhg
:: sdghdjkghdfjkghdjkghdfkjghdfghjkghjkghdkjsdjriwoerisdfks�dfklgjdfkgljdkfgjdkfgjdfngdfkgdfjgkdjfgkjd
:: sdfjsdkgjdrighgjkghdfkghdjkghdjkghdjkghjdkgkhditueruiteioskldruidkrukudrudrdurunsdkdfgjkfgdkdkdjhhh
:: dfkgjdkfgdjkgjdfgjdjhidgjlkdgjdfjglyoudfjkfhgfhdfjkhavedjkhsdfhsdkjdjhsdhjksdjsdfhsdkfhsdfshdfksdhh
:: kxfgljdfgkjdfgkldgjdfgjdfkgjdfgjkgjdfgdgjljdfkgjdfjxxjkxjkxjksdnvnkdngkgkdbgkbnrlebfksbngldbfkrbdih
:: sdghdjkghdfjkghdjkghdfkjghdfghjkghjkghdkjsdjriwoerisdfks�dfklgjdfkgljdkfgjdkfgjdfngdfkgdfjgkdjfgkjd
:: sdfjsdkgjdrighgjkghdfkghdjkghdjkghdjkghjdkgkhditueruiteioskldruidkrukudrudrdurunsdkdfgjkfgdkdkdjhhh
:: dfkgjdkfgdjkgjdfgjdjhidgjlkdgjdfjglyoudfjkfhgfhdfjkhavedjkhsdfhsdkjdjhsdhjksdjsdfhsdkfhsdfshdfksdhh
:: kxfgljdfgkjdfgkldgjdfgjdfkgjdfgjkgjdfgdgjljdfkgjdfjxxjkxjkxjksdnvnkdngkgkdbgkbnrlebfksbngldbfkrbdih
:: fgjdklgjdlfjrgkljglfjgkldfjgkldjgdklgjdfjkdgjdklgjdfgjkdfkgjdfjklgdklgjdkfgjljafgkldfjgdkgjawfbayhg
:: sdghdjkghdfjkghdjkghdfkjghdfghjkghjkghdkjsdjriwoerisdfks�dfklgjdfkgljdkfgjdkfgjdfngdfkgdfjgkdjfgkjd
:: sdfjsdkgjdrighgjkghdfkghdjkghdjkghdjkghjdkgkhditueruiteioskldruidkrukudrudrdurunsdkdfgjkfgdkdkdjhhh
:: dfkgjdkfgdjkgjdfgjdjhidgjlkdgjdfjglyoudfjkfhgfhdfjkhavedjkhsdfhsdkjdjhsdhjksdjsdfhsdkfhsdfshdfksdhh
:: kxfgljdfgkjdfgkldgjdfgjdfkgjdfgjkgjdfgdgjljdfkgjdfjxxjkxjkxjksdnvnkdngkgkdbgkbnrlebfksbngldbfkrbdih
:: sdghdjkghdfjkghdjkghdfkjghdfghjkghjkghdkjsdjriwoerisdfks�dfklgjdfkgljdkfgjdkfgjdfngdfkgdfjgkdjfgkjd
:: sdfjsdkgjdrighgjkghdfkghdjkghdjkghdjkghjdkgkhditueruiteioskldruidkrukudrudrdurunsdkdfgjkfgdkdkdjhhh
:: dfkgjdkfgdjkgjdfgjdjhidgjlkdgjdfjglyoudfjkfhgfhdfjkhavedjkhsdfhsdkjdjhsdhjksdjsdfhsdkfhsdfshdfksdhh
:: kxfgljdfgkjdfgkldgjdfgjdfkgjdfgjkgjdfgdgjljdfkgjdfjxxjkxjkxjksdnvnkdngkgkdbgkbnrlebfksbngldbfkrbdih
:: fgjdklgjdlfjrgkljglfjgkldfjgkldjgdklgjdfjkdgjdklgjdfgjkdfkgjdfjklgdklgjdkfgjljafgkldfjgdkgjawfbayhg
:: sdghdjkghdfjkghdjkghdfkjghdfghjkghjkghdkjsdjriwoerisdfks�dfklgjdfkgljdkfgjdkfgjdfngdfkgdfjgkdjfgkjd
:: sdfjsdkgjdrighgjkghdfkghdjkghdjkghdjkghjdkgkhditueruiteioskldruidkrukudrudrdurunsdkdfgjkfgdkdkdjhhh
:: dfkgjdkfgdjkgjdfgjdjhidgjlkdgjdfjglyoudfjkfhgfhdfjkhavedjkhsdfhsdkjdjhsdhjksdjsdfhsdkfhsdfshdfksdhh
:: kxfgljdfgkjdfgkldgjdfgjdfkgjdfgjkgjdfgdgjljdfkgjdfjxxjkxjkxjksdnvnkdngkgkdbgkbnrlebfksbngldbfkrbdih
:: sdghdjkghdfjkghdjkghdfkjghdfghjkghjkghdkjsdjriwoerisdfks�dfklgjdfkgljdkfgjdkfgjdfngdfkgdfjgkdjfgkjd
:: sdfjsdkgjdrighgjkghdfkghdjkghdjkghdjkghjdkgkhditueruiteioskldruidkrukudrudrdurunsdkdfgjkfgdkdkdjhhh
:: dfkgjdkfgdjkgjdfgjdjhidgjlkdgjdfjglyoudfjkfhgfhdfjkhavedjkhsdfhsdkjdjhsdhjksdjsdfhsdkfhsdfshdfksdhh
:: kxfgljdfgkjdfgkldgjdfgjdfkgjdfgjkgjdfgdgjljdfkgjdfjxxjkxjkxjksdnvnkdngkgkdbgkbnrlebfksbngldbfkrbdih
:: sdfjsdkgjdrighgjkghdfkghdjkghdjkghdjkghjdkgkhditueruiteioskldruidkrukudrudrdurunsdkdfgjkfgdkdkdjhhh
:: dfkgjdkfgdjkgjdfgjdjhidgjlkdgjdfjglyoudfjkfhgfhdfjkhavedjkhsdfhsdkjdjhsdhjksdjsdfhsdkfhsdfshdfksdhh
:: kxfgljdfgkjdfgkldgjdfgjdfkgjdfgjkgjdfgdgjljdfkgjdfjxxjkxjkxjksdnvnkdngkgkdbgkbnrlebfksbngldbfkrbdih