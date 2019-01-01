#InstallKeybdHook
#SingleInstance force
#NoTrayIcon
DetectHiddenWindows True

Editor := "\Program Files\Microsoft VS Code\Code.exe"

/*
Hotkeys:
Alt-A: make window always on top

Alt-Shift-Wheel: Change transparency
*/

increment := 255 * 0.10
wheelIncrement := 255 * 0.05
messageTimeout := 1500

ShowMessage("Window transparentor running")

!a::
  currentWindow := WinGetID("A")
  windowStyle := WinGetExStyle("ahk_id " currentWindow)

  if (windowStyle & 0x8) { ; 0x8 is WS_EX_TOPMOST.
    ShowMessage("- Always on top [" . currentWindow . "]")
    WinSetAlwaysOnTop(0, "ahk_id " currentWindow)
  } else {
    ShowMessage("+ Always on top [" . currentWindow . "]")
    WinSetAlwaysOnTop(1, "ahk_id " currentWindow)
  }
Return

!+WheelUp::
  changeTransparency(+wheelIncrement)
Return

!+WheelDown::
  changeTransparency(-wheelIncrement)
Return

; !x::
;   currentWindow := WinGetID("A")
;   MouseGetPos(x, y, mouseWindow)
;   ShowMessage("currentWindow: " currentWindow " mouseWindow: " mouseWindow)
; Return

; !z::
;   ; MouseGetPos(x, y, mouseWindow)
;   mouseWindow := WinGetID("A")
;   ShowMessage("- ClickThrough")
;   currentStyle := WinGetExStyle("ahk_id " mouseWindow)
;   WinSetExStyle(currentStyle ^ 0x20, "ahk_id " mouseWindow)
;   if (currentStyle & 0x20) {
;     ShowMessage("- ClickThrough")
;   } else {
;     ShowMessage("+ ClickThrough")
;   }
;   ; WinSetExStyle(0xCF0000 | 0x80880000 | 0xC00000 | 0x80000 | 0x20000, "ahk_id " mouseWindow)
;   ; WinSetExStyle(0x100, "ahk_id " mouseWindow)
;   MouseGetPos(x, y, mouseWindow)
;   currentStyle := WinGetExStyle("ahk_id " mouseWindow)
;   ShowMessage("style: " currentStyle "window: " mouseWindow)
; Return

changeTransparency(amount) {
  ; currentWindow := WinGetID("A")
  MouseGetPos(x, y, currentWindow)

  if (currentWindow) {
    currentLevel := WinGetTransparent("ahk_id " currentWindow) || 255
    transparency := Max(1, Min(255, currentLevel + amount))
    ShowMessage("Transparency: " Floor(transparency / 255 * 100) "%")
    WinSetTransparent(transparency, "ahk_id " currentWindow)
  }
}

ShowMessage(message) {
  global messageTimeout
  ToolTip(message)
  SetTimer("HideToolTip", -messageTimeout)
}

HideToolTip() {
  ToolTip()
}
