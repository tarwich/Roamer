
;  __________________________________________________ 
; / Preamble                                         \		; {{{
;

; \__________________________________________________/		; }}}

;  __________________________________________________ 
; / Configuration                                    \		; {{{
;
#SingleInstance force
#NoTrayIcon
; \__________________________________________________/		; }}}

;  __________________________________________________ 		
; / Hotkeys                                          \		; {{{
;
;TAB::Gosub Snippets_CheckSnippets
; \__________________________________________________/		; }}}


; --------------------------------------------------
;
; Application
;
; --------------------------------------------------

SetTitleMatchMode, RegEx

; Shift Fix
;RShift::LShift

; AHK => AutoHotkey
:*:ahk`t::
	SendInput, AutoHotkey
Return
; QB => QueryBuilder
:*:QB`t::
	SendInput, QueryBuilder
Return
; SD => SammyD
:*:SD`t::
	SendInput, SammyD
Return
; VA => Veterans Affairs
:*:VA`t::
	SendInput, Veterans Affairs
Return
; WTF => Worship Teaching Friends
:*:WTF`t::
	SendInput, Worship Teaching Friends
Return

#IfWinActive  - SharpDevelop$ 		; {{{

^w::SendInput, ^{F4}

#IfWinActive 		; }}}

#IfWinActive ^Red Alert 2$		; {{{
MButton::
	Send {Click 5}
	Return
+MButton::
	Send {Click Right 5}
	Return

#IfWinActive		; }}}

#IfWinActive ^Yuri's Revenge$		; {{{
MButton::
	Send {Click 5}
	Return
+MButton::
	Send {Click Right 5}
	Return

#IfWinActive		; }}}

#IfWinActive ^Terraria:.*$ ; {{{
MButton::
	SetTimer ClickTimer, 10
	Return
MButton Up::
	SetTimer ClickTimer, Off
	Return

ClickTimer:
	Send {Click}
Return

#IfWinActive		; }}}
