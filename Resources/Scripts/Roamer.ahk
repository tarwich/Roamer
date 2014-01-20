#SingleInstance force
#Persistent
#Include <AutoUpdate>

; --------------------------------------------------
; Main
; 
; Main program entry point
; --------------------------------------------------
Main:
	; Change into the base directory of the script
	SetWorkingDir %A_ScriptDir%/../../
		
	; Constants
	APPLICATIONS_DIR := A_WorkingDir . "\Resources\Applications"
	SCRIPT_DIR := A_WorkingDir . "\Resources\Scripts"
	AUTOHOTKEY_EXE := APPLICATIONS_DIR . "\AutoHotkey\AutoHotkey.exe"
	DATA_DIR := A_WorkingDir	. "\Resources\data"
	
	global Roamer := {DataDir:DATA_DIR
		, ApplicationsDir: APPLICATIONS_DIR
		, ScriptDir: SCRIPT_DIR
		, Ahk: AUTOHOTKEY_EXE
		, ConfigFile: DATA_DIR . "\Roamer.cfg"
		, Autoload: []}
	
	file := FileOpen(Roamer.ConfigFile, "r")
	
	while(!file.AtEOF)
	{
		line := file.ReadLine()
		
		if(SubStr(line, 1, 1) != "`t")
			section = % SubStr(line, 1, InStr(line, ":")-1)
		else
		{
			i := InStr(line, ":")
			key := RegExReplace(SubStr(line, 1, i-1), "(^\s*|\s*$)")
			value := RegExReplace(SubStr(line, i+1), "(^\s*|\s*$)")
			
			if(section == "Autoload")
				Roamer.Autoload[key] := value
		}
	}
	
	file.Close()
		
	; Setup the menu that should show in the tray
	Gosub SetupTrayMenu
	; Run the applications
	Gosub LaunchStartupApplications
Return



; --------------------------------------------------
; Disabled
; 
; Dummy item for empty menus
; --------------------------------------------------
Disabled:
	MsgBox, % "This item is disabled"
Return

; --------------------------------------------------
; Launch Startup Applications
; --------------------------------------------------
LaunchStartupApplications:
	for script, isEnabled in Roamer.Autoload
		if(isEnabled)
			Run, % """" . Roamer.Ahk """" . " """ . Roamer.ScriptDir . "\" . script . """"
Return

; --------------------------------------------------
; Make Start Menu
; --------------------------------------------------
MakeStartMenu:
	; - Programs Menu ---------------------------8<-----
	; ------------------------------------------>8------
	
	; - Scripts Menu ----------------------------8<-----
	Count := 0
	
	Loop, % A_ScriptDir . "\*.ahk"
	{
		; Skip Roamer.ahk
		if(A_LoopFileName = "Roamer.ahk")
			Continue
		Menu, ScriptsMenu, Add, % A_LoopFileName, RunScript
		if(Roamer.Autoload[A_LoopFileName])
			Menu, ScriptsMenu, Check, % A_LoopFileName
		Count += 1
	} 
	
	; If no files were found, then show an item saying nothing was found
	if(!Count) 
	{
		; Add an item to say that scripts aren't found
		Menu, ScriptsMenu, Add, (No Scripts), Disabled
		; Ensure the added item is disabled
		Menu, ScriptsMenu, Disable, (No Scripts)
	}
	; ------------------------------------------>8------	
	
	Menu, StartMenu, Add, Scripts, :ScriptsMenu
Return

SaveSettings()
{
	global Roamer
	
	file := FileOpen(Roamer.ConfigFile, "w")
	file.WriteLine("Autoload:")
	
	for script, isEnabled in Roamer.Autoload
		if(isEnabled) 
			file.WriteLine("`t" . script . ": " . isEnabled)
	
	file.Close()
}

; --------------------------------------------------
; Setup Tray Menu
; --------------------------------------------------
SetupTrayMenu:
	; Set the tray icon	
	Menu, Tray, Icon, .\Resources\Images\flash-drive.ico
	; Set the caption
	Menu, Tray, Tip, Roamer
	; Make the start menu
	Gosub MakeStartMenu
	; Add the custom start menu entry
	Menu, Tray, Add, Start Menu, ShowStartMenu
	; Make the start menu the default
	Menu, Tray, Default, Start Menu
	; Allow single click
	Menu, Tray, Click, 1
return ; /*}}}*/

; --------------------------------------------------
; Show Start Menu
; --------------------------------------------------
ShowStartMenu: 
	Menu, StartMenu, Show
Return

; --------------------------------------------------
; Run Script
; --------------------------------------------------
RunScript:
	if(GetKeyState("SHIFT"))
	{
		Roamer.Autoload.Insert(A_ThisMenuItem, !Roamer.Autoload[A_ThisMenuItem])
		if(Roamer.Autoload[A_ThisMenuItem])
			Menu, ScriptsMenu, Check, % A_ThisMenuItem
		else
			Menu, ScriptsMenu, Uncheck, % A_ThisMenuItem
		SaveSettings()
	}
	else
	{
		Run, % AUTOHOTKEY_EXE . " " . SCRIPT_DIR . "\" .  A_ThisMenuItem
	}
Return
