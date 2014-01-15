
;  __________________________________________________ 
; / Preamble                                         \		; {{{
;

; \__________________________________________________/		; }}}

;  __________________________________________________ 
; / Configuration                                    \		; {{{
;
#SingleInstance force
;#NoTrayIcon
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

#IfWinActive Eclipse$	; {{{

; !NS => (Insert namespace garb)
:*:!NS`t::
	oldClipboard = %clipboard%
	clipboard = <script type='text/javascript'>
	clipboard = %clipboard%`n(function(NS, $) {
	clipboard = %clipboard%`n	//  __________________________________________
	clipboard = %clipboard%`n	// /---------- Initialize namespace ----------\
	clipboard = %clipboard%`n	(window[NS]) || (window[NS] = {});
	clipboard = %clipboard%`n	var $ns, ns = window[NS];
	clipboard = %clipboard%`n	// \__________________________________________/
	clipboard = %clipboard%`n	
	clipboard = %clipboard%`n	//  _[ Initialize ]___________________________________
	clipboard = %clipboard%`n	// |                                                  |
	clipboard = %clipboard%`n	// | One-time initialization of namespace             |
	clipboard = %clipboard%`n	// |__________________________________________________|
	clipboard = %clipboard%`n	ns.initialize = function() {
	clipboard = %clipboard%`n		// Find the namespace element
	clipboard = %clipboard%`n		$ns = $("." + NS);
	clipboard = %clipboard%`n		// Connect event listeners
	clipboard = %clipboard%`n		ns.rebind();
	clipboard = %clipboard%`n	};
	clipboard = %clipboard%`n	
	clipboard = %clipboard%`n	//  _[ Rebind ]_______________________________________
	clipboard = %clipboard%`n	// |                                                  |
	clipboard = %clipboard%`n	// | Reconnect event listeners to their elements      |
	clipboard = %clipboard%`n	// | (usually as a result of an ajax call)            |
	clipboard = %clipboard%`n	// |__________________________________________________|
	clipboard = %clipboard%`n	ns.rebind = function() {
	clipboard = %clipboard%`n	};
	clipboard = %clipboard%`n
	clipboard = %clipboard%`n	$(ns.initialize);
	clipboard = %clipboard%`n})("", jQuery);
	clipboard = %clipboard%`n</script>
	SendInput, ^v
	SendInput, {LEFT 21}
	Sleep, 300
	clipboard = %oldClipboard%
Return

:*:|__`t::
	oldClipboard = %clipboard%
	clipboard =              //  __________________________________________________
	clipboard = %clipboard%`n// |                                                  |
	clipboard = %clipboard%`n// |                                                  |
	clipboard = %clipboard%`n// |__________________________________________________|
	SendInput, ^v
	SendInput, {Up 3}
	Sleep, 300
	clipboard = %oldClipboard%
Return

:*:// /`t::
	oldClipboard = %clipboard%
	clipboard = %clipboard%`n
	clipboard =              //  __________________________________________________
	clipboard = %clipboard%`n// /                                                  \
	clipboard = %clipboard%`n
	clipboard = %clipboard%`n// \__________________________________________________/
	clipboard = %clipboard%`n
	
	SendInput, ^v
	SendInput, {Up 3}{Right 5}{Insert}
	Sleep, 300
	clipboard = %oldClipboard%
Return

#IfWinActive ; }}}

