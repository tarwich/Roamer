#InstallKeybdHook
#SingleInstance force
#NoTrayIcon

Editor := "\Program Files\Microsoft VS Code\Code.exe"

RButton & MButton::
Media_Play_Pause::
  hwnd := WinGetId("ahk_class mpv")

  if (hwnd) {
    ControlSend(" ", , "ahk_class mpv")
  }
Return

$RButton::
  Send "{RButton}"
Return

RButton & WheelUp::Send "{Volume_Up}"
RButton & WheelDown::Send "{Volume_Down}"
