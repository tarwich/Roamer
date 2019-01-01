#InstallKeybdHook
#SingleInstance force
#NoTrayIcon

Editor := "\Program Files\Microsoft VS Code\Code.exe"

Media_Play_Pause::
  hwnd := WinGetId("ahk_class mpv")

  if (hwnd) {
    ControlSend(" ", , "ahk_class mpv")
  }
Return
