#SingleInstance force

DetectHiddenWindows("On")

Editor := "\Program Files\Microsoft VS Code\Code.exe"

SetWorkingDir(A_ScriptDir)

ArrayJoin(array, glue := "`n") {
  result := ""

  for (i, item in array) {
    result .= item glue
  }

  return result
}

class Menu {
  __New() {
    this.menu := MenuCreate()
    this.items := []
  }

  Add(name, callback) {
    item := new MenuItem(this, name, callback)
    this.items.Push(item)
    this.menu.Add(name, ObjBindMethod(item, "HandleClick", 1))
    return item
  }

  Rename(a, b) {
    this.menu.Rename(a, b)
  }

  Show() {
    this.menu.Show()
  }
}

class MenuItem {
  __New(menu, name, callback) {
    this.menu := menu
    this.name := name
    this.callback := callback
  }

  HandleClick() {
    this.callback.Call(this)
  }

  Rename(newName) {
    if (newName != this.name) {
      this.menu.Rename(this.name, newName)
      this.name := newName
    }
  }
}

class Module {
  __New(file) {
    this.pid := 0
    this.fileName := file
    this.scriptDir := A_ScriptDir "\ahk\"
    this.scriptPath := A_ScriptDir "\ahk\" file
    parts := StrSplit(file, ".ahk")
    this.name := parts[1]
  }

  Run() {
    Run(A_ScriptDir "\bin\AutoHotkeyU64.exe " "`"" this.scriptPath "`"", this.scriptDir, , pid)
    this.pid := pid
  }

  IsRunning() {
    if (this.pid and ProcessExist(this.pid)) {
      return True
    }

    for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process Where Name = 'AutoHotkeyU64.exe' AND CommandLine LIKE '%" A_ScriptName "%'") {
      this.pid := process.Handle
    }

    return this.pid and ProcessExist(this.pid)
  }

  Stop() {
    if (this.IsRunning()) {
      hwnd := WinGetID("ahk_pid " this.pid)
      WinClose("ahk_id " hwnd)
    }

    this.pid := 0
  }
}

class Roamer {
  __New() {
    this.menu := new Menu()
  }

  LoadInstalledScripts() {
    this.modules :=  []

    Loop Files A_ScriptDir "\ahk\*" {
      module := new Module(A_LoopFileName)
      this.modules.Push(module)
      module.menuItem := this.menu.Add(module.name, ObjBindMethod(this, "ModuleWasClicked", module))

      if (IniRead(A_ScriptDir "\roamer.ini", "Active Modules", module.name, False)) {
        module.Run()
      }
    }

    this.UpdateMenu()
  }

  HandleExit() {
    for (i, module in this.modules) {
      module.Stop()
    }
  }

  ModuleWasClicked(module, menu) {
    if (module.IsRunning()) {
      module.Stop()
      IniWrite(False, A_ScriptDir "\roamer.ini", "Active Modules", module.name)
    }
    else {
      module.Run()
      IniWrite(True, A_ScriptDir "\roamer.ini", "Active Modules", module.name)
    }

    this.UpdateMenu()
  }

  ShowMenu() {
    this.menu.Show()
  }

  UpdateMenu() {
    for (i, module in this.modules) {
      menuOn := module.name " [On]"
      menuOff := module.name

      if (module.IsRunning()) {
        module.menuItem.Rename(menuOn)
      }
      else {
        module.menuItem.Rename(menuOff)
      }
    }
  }
}

roamer := new Roamer()
roamer.LoadInstalledScripts()

OnMessage(0x404, "AHK_TRAYEVENT")
AHK_TRAYEVENT(wParam, lParam) {
  if (lParam = 0x201) {
    roamer.ShowMenu()
  }
}

OnExit(ObjBindMethod(roamer, "HandleExit"))
