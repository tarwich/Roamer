
;  __________________________________________________
; / PREAMBLE                                         \ {{{

	; This script was created to port EasyWindowDrag_KDE 
	; to Windows 7 and add support for Synergy+

; \__________________________________________________/ }}}

;  __________________________________________________ 
; / CONFIGURATION                                    \ {{{

#Include %A_ScriptDir%\lib\SystemMetrics.ahk

	; Don't allow more than one copy to run at a time
	#SingleInstance force
	; Disable tray icon
	#NoTrayIcon
	; Becuase some applications will not allow AHK to see the ALT key.  You can 
	; remove this line if you want your 500k of memory back
	#InstallKeybdHook
	; Affects the smoothness of the window dragging.  2 is best on my system
	SetWinDelay, 2

; \__________________________________________________/ }}}

;  __________________________________________________ 
; / HOTKEYS                                          \ {{{

	; Must return to prevent AHK from executing Hotkeys while parsing
	return

	; Dragging
	#LButton::Gosub, StartDragging
	#LButton UP::Gosub, StopDragging

	; Sizing
	#RButton::Gosub, StartSizing
	#RButton UP::Gosub, StopSizing

	; Shade (Roll up/down)
	; $WheelUp::Gosub, RollUp
	; $WheelDown::Gosub, RollDown

; \__________________________________________________/ }}}

; --------------------------------------------------
; 
; Application
; 
; --------------------------------------------------

;  _GetOffsets_______________________________________ {{{
; |                                                  | 
; | This is required in order to determine the       | 
; | amount of change in each increment.              | 
; |__________________________________________________| 
GetOffsets:
	; Store the relative offset of the cursor for absolute movement later
	CoordMode, Mouse, Screen
	MouseGetPos, startX, startY, window
	WinGetPos, winX, winY, winWidth, winHeight, ahk_id %window%
	offsetX := startX - winX
	offsetY := startY - winY

	; Remember the original size of the window
	originalWidth := winWidth
	originalHeight := winHeight
	
	; Figure out what direction we should be sizing
	percentX := offsetX / winWidth * 100
	percentY := offsetY / winHeight * 100
	
	if(percentX >= 0)
		sizeX = W
	if(percentX >= 20)
		sizeX = W
	if(percentX >= 40)
		sizeX = 
	if(percentX >= 60)
		sizeX = E
	if(percentX >= 80)
		sizeX = E
	
	if(percentY >= 0)
		sizeY = N
	if(percentY >= 20)
		sizeY = N
	if(percentY >= 40)
		sizeY = 
	if(percentY >= 60)
		sizeY = S
	if(percentY >= 80)
		sizeY = S
return ; }}}

;  _MoveTimer________________________________________ {{{
; |                                                  |
; | Each time this timer fires, the window will      |
; | move one increment relative to the original      |
; | offset.                                          |
; |__________________________________________________|
MoveTimer:
	CoordMode, Mouse, Screen
	MouseGetPos, mouseX, mouseY
	; Calculate the new position of the window
	newX := mouseX - offsetX
	newY := mouseY - offsetY
	; Actually move the window
	WinMove, ahk_id %window%,, newX, newY 
	;ToolTip, ahk_id %window%-- %newX%- %newY% 
return ; }}}

;  _RollDown_________________________________________ {{{
; |                                                  |
; | Rolls the window back down to its original       |
; | height                                           |
; |__________________________________________________|
RollDown:
	; Get the window under the cursor
	Gosub, GetOffsets
	; See if the mouse is over the title bar
	if(startY > winY + titleBarHeight) {
		Send, {WheelDown}
		return
	}
	
	; Unset the region value, which restores the window to its 
	; original height
	WinSet, Region, , ahk_id %window%
return ; }}}

;  _RollUp___________________________________________ {{{
; |                                                  |
; | Rolls the window up so that only the title bar   |
; | is visible                                       |
; |__________________________________________________|
RollUp:
	; Get the window under the cursor
	Gosub, GetOffsets
	; Figure out how high the title bar should be
	SysGet, titleBarHeight, %SM_CYMIN%

	; Make sure the height is more than 20px
	if(titleBarHeight < 20)	{
		titleBarHeight = 20;
	}

	; See if the mouse is over the title bar
	if(startY > winY + titleBarHeight) {
		Send, {WheelUp}
		return
	}

	; Shrink the window to the title bar
	WinSet, Region, 0-0 W%winWidth% H%titleBarHeight%, ahk_id %window%
return ; }}}

;  _SizeTimer________________________________________ {{{
; |                                                  | 
; | Each time this timer fires, it will size the     |
; | window one increment.                            |
; |__________________________________________________| 
SizeTimer:
	CoordMode, Mouse, Screen
	MouseGetPos, mouseX, mouseY
	
	if(sizeX = "W") {
		newWidth := originalWidth + startX - mouseX
		newX := mouseX - offsetX
	} else if(sizeX = "E") {
		newWidth := originalWidth + mouseX - startX
		newX := winX
	}

	if(sizeY = "N") {
		newHeight:= originalHeight + startY - mouseY
		newY := mouseY - offsetY
	} else if(sizeY = "S") {
		newHeight := originalHeight + mouseY - startY
		newY := winY
	}

	WinMove, ahk_id %window%,, newX, newY, newWidth, newHeight
return ; }}}

;  _StartDragging____________________________________ {{{
; |                                                  | 
; | Perform actions necessary to initiate the drag.  |
; |__________________________________________________| 
StartDragging:
	Gosub, GetOffsets
	; Start the timer to move the window
	SetTimer, MoveTimer, 50	
return ; }}}

;  _StopDragging_____________________________________ {{{
; |                                                  |
; | Finish dragging the window.                      |
; |__________________________________________________|
StopDragging:
	; Stop the move window timer
	SetTimer, MoveTimer, Off
return ; }}}

;  _StartSizing______________________________________ {{{
; |                                                  | 
; | Perform actions necessary to initiate the sizing |
; |__________________________________________________| 
StartSizing:
	Gosub, GetOffsets
	; Start the timer to size the window
	SetTimer, SizeTimer, 50	
return ; }}}

;  _StopSizing_______________________________________ {{{
; |                                                  |
; | Fininsh sizing the window                        |
; |__________________________________________________|
StopSizing:
	; Stop the size window timer
	SetTimer, SizeTimer, Off
return ; }}}

