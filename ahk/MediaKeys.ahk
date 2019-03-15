#InstallKeybdHook
#SingleInstance force
#NoTrayIcon

Editor := "\Program Files\Microsoft VS Code\Code.exe"

Alt & MButton::
Media_Play_Pause::
  hwnd := WinGetId("ahk_class mpv")

  if (hwnd) {
    ControlSend(" ", , "ahk_class mpv")
  }
Return

Alt & WheelUp::Send "{Volume_Up}"
Alt & WheelDown::Send "{Volume_Down}"
