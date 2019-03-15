#InstallKeybdHook
#SingleInstance force
#NoTrayIcon

Editor := "\Program Files\Microsoft VS Code\Code.exe"

Alt & MButton::
Media_Play_Pause::
  hwnd := WinGetId("- mpsyt")

  if (hwnd) {
    ControlSend(" ", , "- mpsyt")
  }
Return

Alt & WheelUp::Send "{Volume_Up}"
Alt & WheelDown::Send "{Volume_Down}"
