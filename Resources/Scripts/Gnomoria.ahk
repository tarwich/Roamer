#SingleInstance force
#Persistent
#include <AutoUpdate>

; Set the tray icon if found
if(FileExist(A_ScriptDir . "\Gnomoria.ico"))
	Menu, Tray, Icon, % A_ScriptDir . "\Gnomoria.ico"

Hotkey, IfWinActive, Gnomoria

Gnomoria_ChordList := []

Gnomoria_AddChord("B"    , "Build")
Gnomoria_AddChord("BF"   , "Furniture"            , 33)
Gnomoria_AddChord("BS"   , "Storage"              , 34)
Gnomoria_AddChord("BT"   , "Terrain")
Gnomoria_AddChord("BTF"  , "Build floor"          , 352)
Gnomoria_AddChord("BTR"  , "Build ramp")
Gnomoria_AddChord("BTRD" , "Build ramp down"      , 356)
Gnomoria_AddChord("BTRU" , "Build ramp up"        , 355)
Gnomoria_AddChord("BTS"  , "Build stairs")
Gnomoria_AddChord("BTSD" , "Build stairs down"    , 354)
Gnomoria_AddChord("BTSU" , "Build stairs up"      , 353)
Gnomoria_AddChord("BTW"  , "Build wall"           , 351)
Gnomoria_AddChord("BW"   , "Workshop"             , 31)
Gnomoria_AddChord("D"    , "Designate")
Gnomoria_AddChord("DC"   , "Designate Great Hall" , 433)
Gnomoria_AddChord("DD"   , "Designate Dorm"       , 432)
Gnomoria_AddChord("DF"   , "Designate Farm"       , 421)
Gnomoria_AddChord("DG"   , "Designate Grove"      , 424)
Gnomoria_AddChord("DH"   , "Designate Hospital"   , 434)
Gnomoria_AddChord("DR"   , "Designate Ranch"      , 423)
Gnomoria_AddChord("DS"   , "Designate Stockpile"  , 41)
Gnomoria_AddChord("F"    , "Farming")
Gnomoria_AddChord("FB"   , "Bushes")
Gnomoria_AddChord("FBF"  , "Forage"               , 28)
Gnomoria_AddChord("FT"   , "Farming trees")
Gnomoria_AddChord("FTC"  , "Chop trees"           , 26)
Gnomoria_AddChord("FTT"  , "Take clipping"        , 27)
Gnomoria_AddChord("M"    , "Mine")
Gnomoria_AddChord("MR"   , "Ramp upward"          , 113)
Gnomoria_AddChord("MS"   , "Stairs upward"        , 112)
Gnomoria_AddChord("MW"   , "Wall"                 , 111)
Gnomoria_AddChord("T"    , "Terrain"        )
Gnomoria_AddChord("TD"   , "Dig")
Gnomoria_AddChord("TDH"  , "Dig hole down"        , 121)
Gnomoria_AddChord("TDR"  , "Dig ramp down"        , 123)
Gnomoria_AddChord("TDS"  , "Dig stairs down"      , 122)
Gnomoria_AddChord("TX", "Swap")
Gnomoria_AddChord("TXW", "Swap wall", 15)
Gnomoria_AddChord("TXF", "Swap floor", 16)
Gnomoria_AddChord("TR"   , "Remove"         )
Gnomoria_AddChord("TRR"  , "Remove ramp"          , 14)
Gnomoria_AddChord("TRRs" , "Remove floor"         , 13)
Gnomoria_AddChord("Z"    , "Back"                 , 9)

Hotkey, ^+L, Gnomoria_ToggleLiteral

Return

; Gnomoria

; --------------------------------------------------
; Gnomoria_AddChord
; --------------------------------------------------
Gnomoria_AddChord(chord, message, action=0, actionMessage=0)
{
	global Gnomoria_ChordList
	
	StringUpper, chord, chord
	
	Loop, Parse, chord
	{
		Hotkey, %A_LoopField%, Gnomoria_Hotkey
		Hotkey, %A_LoopField% UP, Gnomoria_Hotkey_Up
	}
	
	; Default actionMessage to message
	actionMessage := actionMessage ? actionMessage : message
	; Add this chord to the list
	Gnomoria_ChordList[chord] := {chord: chord
	                          ,  message: message
	                          ,  action: action
	                          ,  actionMessage:actionMessage}
}

; --------------------------------------------------
; Gnomoria_HideToolTip
; --------------------------------------------------
Gnomoria_HideToolTip:
	; Clear the current chor
	Gnomoria_Chord := ""
	; Hide the tooltip
	ToolTip,
	SetTimer, Gnomoria_HideToolTip, Off
Return

; --------------------------------------------------
; Gnomoria_Hotkey
; --------------------------------------------------
Gnomoria_Hotkey:
	global Gnomoria_Chord, Gnomoria_LiteralMode
	
	Gnomoria_Chord .= A_ThisHotkey
	
	; If we're in literal mode, then don't do anything with this hotkey
	if(Gnomoria_LiteralMode) 
		Gnomoria_Chord := ""
	
	; Get the chord object for the current chord
	chord := Gnomoria_ChordList[Gnomoria_Chord]
	
	if(chord)
	{
		if(chord.chord == Gnomoria_Chord) 
		{
			message := chord.actionMessage
			
			if(chord.action)
			{
				; Remove the parent name from the message
				Gnomoria_ToolTip(message)
				SetKeyDelay, 50, 50
				Send, % "00000" . chord.action
			}
			else 
			{
				for j, child in Gnomoria_ChordList
				{
					if(SubStr(child.chord, 1, -1) == chord.chord) 
					{
						message .= "`n" . SubStr(child.chord, 0) . " - " . child.message
					}
				}
				
				Gnomoria_ToolTip(message)
			}
						
			; Chord found, so don't process anything else
			Return
		}
	}
	
	; If we got here, then nothing was found, so reset the chord
	Gnomoria_Chord := "" 
	; And send the key to the active application
	Gnomoria_KeyDown(key)
Return

; --------------------------------------------------
; Gnomoria_Hotkey_Up
; --------------------------------------------------
Gnomoria_Hotkey_Up:
	Gnomoria_KeyUp(SubStr(A_ThisHotkey, 1, 1))
Return

; --------------------------------------------------
; Gnomoria_KeyDown
; --------------------------------------------------
Gnomoria_KeyDown(key)
{
	StringLower, key, A_ThisHotkey
	SendInput, {%key% DOWN}
}

; --------------------------------------------------
; Gnomoria_KeyUp
; --------------------------------------------------
Gnomoria_KeyUp(key)
{
	SendInput, {%key% UP}
}

; --------------------------------------------------
; Gnomoria_ToggleLiteral
; --------------------------------------------------
Gnomoria_ToggleLiteral:
	global Gnomoria_LiteralMode
	
	; Invert the literal mode
	Gnomoria_LiteralMode := !Gnomoria_LiteralMode
	; Show the user what's going on
	Gnomoria_ToolTip("Literal mode " (Gnomoria_LiteralMode?"on":"off"))
Return

; --------------------------------------------------
; Gnomoria_ToolTip
; --------------------------------------------------
Gnomoria_ToolTip(message)
{
	ToolTip, %message%
	SetTimer, Gnomoria_HideToolTip, 2000
}
