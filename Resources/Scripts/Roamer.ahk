;  __________________________________________________ 
; / PREAMBLE                                         \ /*{{{*/
; \__________________________________________________/ /*}}}*/

;  __________________________________________________ 
; / CHANGELOG                                        \ /*{{{*/
; 1 Aug 2010
; - Converted engine and script to AutoHotkey_L
; - Fixed bug where tray menu didn't always hide if 
; 	invoked when visible
; - Added COM_L libraries
; 29 Sep 2010
; - Added LiveWindows.ahk to startup programs
; TODO: Make startup programs configurable
; \__________________________________________________/ /*}}}*/

;  __________________________________________________ 
; / CONFIGURATION                                    \ /*{{{*/

#SingleInstance force
#Persistent

MY_NAME = Samuel Dillow
MENU_WIDTH = 100
MENU_HEIGHT = 200

; \__________________________________________________/ /*}}}*/

;  __________________________________________________ 
; / HOTKEYS                                          \ /*{{{*/

; Don't actually execute these hotkeys
Goto Main

; \__________________________________________________/ /*}}}*/

; --------------------------------------------------
; 
;  Application
; 
; --------------------------------------------------

#Include %A_ScriptDir%\lib\WindowMessages.ahk

;  _[ Enable Start Menu ]____________________________/*{{{*/
; |                                                  |
; | Allow the start menu to be displayed             |
; |__________________________________________________|
EnableStartMenu:
	guiVisible = false
return ; /*}}}*/

;  _[ Hide Start Menu ]______________________________/*{{{*/
; |                                                  |
; | Handle closing (hiding) of the GUI window        |
; |__________________________________________________|
HideStartMenu()
{
	Gui, Show, Hide
	; Allow other messages to process before setting 
	; the start menu status to hidden
	SetTimer, EnableStartMenu, -150
} ; /*}}}*/

;  _[ Launch Startup Applications ]__________________/*{{{*/
; |                                                  |
; | Loads the settings for the applications that     |
; | should run on startup, then runs each one.       |
; |__________________________________________________|
LaunchStartupApplications:
	Run, "%AUTOHOTKEY_EXE%" "%AHK_DIR%\EasyDrag7.ahk"
	Run, "%AUTOHOTKEY_EXE%" "%AHK_DIR%\Volume.ahk"
	Run, "%AUTOHOTKEY_EXE%" "%AHK_DIR%\Snippets.ahk"
	Run, "%AUTOHOTKEY_EXE%" "%AHK_DIR%\LiveWindows.ahk"
return ; /*}}}*/

;  _[ Make Start Menu ]______________________________ /*{{{*/
; |                                                  |
; | Make the start menu dialog. Parse settings,      |
; | build program list.                              |
; |__________________________________________________|
MakeStartMenu:
	; Add the picture
	Gui, Add, Picture, x10 y2 h40 w72, Resources\img\flash-drive.png
	; Determine the size
	Gui, Show, Hide w%MENU_WIDTH% h%MENU_HEIGHT%, Start Menu
	; Remove the caption and border
	Gui, -Caption

	; Read all the menu entries
return ; /*}}}*/

;  _[ Setup Tray Menu ]______________________________ /*{{{*/
; |                                                  |
; | setup the tray icon to have the application menu |
; | and the custom icons that go with it.            |
; |__________________________________________________|
SetupTrayMenu:
	; Set the tray icon	
	Menu, Tray, Icon, .\Resources\Images\flash-drive.ico
	; Set the caption
	Menu, Tray, Tip, Roamer
	; Make the start menu
	Gosub MakeStartMenu
	; Add the custom start menu entry
	Menu, Tray, Add, Start Menu, StartMenu
	; Make the start menu the default
	Menu, Tray, Default, Start Menu
	; Allow single click
	Menu, Tray, Click, 1
return ; /*}}}*/

;  _[ Show Start Menu ]______________________________/*{{{*/
; |                                                  |
; | Show the start menu                              |
; |__________________________________________________|
StartMenu:
	ShowStartMenu()
return
ShowStartMenu()
{
	global MENU_WIDTH, MENU_HEIGHT
	global guiVisible
	
	if (guiVisible = 1) {
		HideStartMenu()
	} else {
		CoordMode, Mouse, Screen
		MouseGetPos, mouseX, mouseY

		; Figure out where we should put the menu
		x := mouseX
		y := mouseY - MENU_HEIGHT

		; Make sure the menu isn't running off the screen
		if(x > A_ScreenWidth - MENU_WIDTH) {
			x = A_ScreenWidth - MENU_WIDTH
		}
		
		; Finally, show the menu
		Gui, Show, x%x% y%y%
		; Remember that the GUI is visible
		guiVisible = 1
	}
} ;/*}}}*/

;  _[ WM_ACTIVATE ]__________________________________ /*{{{*/
; |                                                  |
; | Called when the gui window gets or loses focus   |
; |__________________________________________________|
WM_ACTIVATE(wParam, lParam, msg, hwnd)
{
	OutputDebug, WM_ACTIVATE wParam: %wParam% lParam: %lParam% hwnd: %hwnd%
	
	if(wParam = 0) ; wParam 0 means lost focus
	{
		HideStartMenu()
	}
} ; /*}}}*/

;  _[ Main ]_________________________________________ /*{{{*/
; |                                                  |
; | Main program entry point                         |
; |__________________________________________________|
Main:
	; Change into the base directory of the script
	SetWorkingDir %A_ScriptDir%/../../
	
	; Constants
	APPLICATIONS_DIR = %A_WorkingDir%\Resources\Applications
	AHK_DIR = %A_WorkingDir%\Resources\Scripts
	AUTOHOTKEY_EXE = %APPLICATIONS_DIR%\AutoHotkey\AutoHotkey.exe

	; Listen to messages
	OnMessage(WM_LBUTTONDOWN , "WM_LBUTTONDOWN" )
	OnMessage(WM_LBUTTONUP   , "WM_LBUTTONUP"   )
	OnMessage(WM_ACTIVATE    , "WM_ACTIVATE"    )

	; Setup the menu that should show in the tray
	Gosub SetupTrayMenu
	; Run the applications
	Gosub LaunchStartupApplications
return ; /*}}}*/

