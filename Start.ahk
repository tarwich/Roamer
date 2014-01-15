
SetWorkingDir %A_ScriptDir%

APPLICATIONS_DIR = %A_ScriptDir%\Resources\Applications
AUTOHOTKEY_EXE = %APPLICATIONS_DIR%\AutoHotkey\AutoHotkey.exe
AHK_DIR = %A_ScriptDir%\Resources\Scripts

Run, "%AUTOHOTKEY_EXE%" "%AHK_DIR%\Roamer.ahk", "%A_ScriptDir%"

