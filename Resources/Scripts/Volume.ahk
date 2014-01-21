#SingleInstance force
#NoTrayIcon

;---------- Volume OSD

;------ User Variables ( Feel free to change these )

Gui_X          := ""
Gui_Y          := "y50"
Back_Colour    := 0x000000
Font_Colour    := 0xFFFFFF
BackBar_Colour := 0x000000
Bar_Colour     := 0x0000FF
VolUp_Keys     := ["#WheelUp", "#UP"]
VolDown_Keys   := ["#WheelDown", "#DOWN"]
VolMute_Keys   := [ "#MButton", "#ESC" ]
Ammount        := 2
Timeout        := 700
Max_Trans      := 200


;------- End of user variables


Update              := 0

SoundGet, Vol
Curr_Vol            := Vol

Trans               := Max_Trans

Gui, -Caption +ToolWindow +AlwaysOnTop 
Gui, Color, % Back_Colour, 
Gui, Font, c%Font_Colour% s12
Gui, Add, Text, w500 Center, Volume
Gui, Font
Gui, Add, Progress, w500 vProgress c%Bar_Colour% +Background%BackBar_Colour%, % Curr_Vol
Gui, Font, c%Font_Colour% s24
SoundGet, Vol
RegExMatch( Vol, "(?<Percent>\d+)\.", rg )
Gui, Add, Text, w500 Center vVol, % rgPercent
Gui, Show, NoActivate h105 w530 %Gui_X% %Gui_Y%, Vol_OSD

WinSet, Region, w530 h105 R10-10 0-0, Vol_OSD
WinSet, Transparent, %Trans%, Vol_OSD


; Gui, -Caption +AlwaysOnTop +ToolWindow +E0x20 +SysMenu
for i, key in VolUp_keys
	Hotkey, % key, Volume_Up
for i, key in VolDown_Keys
	Hotkey, % key, Volume_Down
for i, key in VolMute_Keys 
	Hotkey, % key, Volume_MuteUnmute
SetTimer, Update, 50

SetTimer, Fade, % "-" Timeout

return


Fade:
	While ( Trans > 0 && Update = 0)
	{   Trans -= 10
		WinSet, Transparent, % Trans, Vol_OSD
		Sleep, 5
	}
Return


Update:
	Update              := 0
	SoundGet, Vol
	If ( Vol <> Curr_Vol )
	{   Update          := 1
		GuiControl,, Progress, % Vol
		RegExMatch( Vol, "(?<Percent>\d+)\.", rg )
		GuiControl,, Vol, % rgPercent
		Curr_Vol        := Vol
		
		While ( Trans < Max_Trans )
		{   Trans       += 20
			WinSet, Transparent, % Trans, Vol_OSD 
			Sleep 1
		}   
		SetTimer, Fade, % "-" Timeout
	}
Return

Volume_Down:
	SoundSet, -%Ammount%, MASTER
return


Volume_Up:
	SoundSet, +%Ammount%, MASTER
Return

Volume_MuteUnmute:
	SoundSet, +1, , MUTE
Return
