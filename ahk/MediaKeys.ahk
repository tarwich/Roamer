; #InstallKeybdHook
; #InstallMouseHook
#SingleInstance force
; #NoTrayIcon
#MaxHotkeysPerInterval 100

; Hotkey("^!+r", () => Reload())
; MsgBox("MediaKeys Loaded")

new VerticalOSD({
  keys: {
    volumeUp: ["!WheelUp", "Volume_Up"],
    volumeDown: ["!WheelDown", "Volume_Down"],
    playPause: ["!MButton", "~Media_Play_Pause"],
    playNext: ["~Media_Next"],
    playPrevious: ["~Media_Prev"],
  }
})

class VerticalOSD {
  x      := 50
  y      := 60
  width  := 65
  height := 140

  backColor    := "101010"
  fontColor    := "FFFFFF"
  barBackColor := "808080"
  barColor     := "0076D7"

  timeout         := 1000
  amount          := 1
  pollInterval    := 100
  updateInterval  := 10
  maxTransparency := 240

  keys := {
    volumeUp: ["!WheelUp"],
    volumeDown: ["!WheelDown"],
  }

  ; @param {integer} options.width The width of the OSD in pixels
  ; @param {integer} options.height The height of the OSD in pixels
  ; @param {integer} options.x The x position of the OSD in pixels. Use "" to center OSD on screen
  ; @param {integer} options.y The y position of the OSD in pixels. Use "" to center OSD on screen
  __New(options) {
    if (options) {
      for (key, value in options) {
        if (key == "keys") {
          for (key2, value2 in value) {
            if (value is "string") {
              this.keys[key2] := [value2]
            }
            else {
              this.keys[key2] := value2
            }
          }
        }
        else {
          this[key] := value
        }
      }
    }

    global VolUp_Key, VolDown_Key,
    this.gui := GuiCreate()
    this.volume := SoundGet()
    this.transparency := 0
    this.currentVol := this.volume
    Control_W := this.width - 30
    barWidth := 12

    this._fade := () => this.Fade()
    this._update := () => this.Update()
    this._volumeUp := () => this.VolumeUp()
    this._volumeDown := () => this.VolumeDown()
    this._playPause := () => this.PlayPause()
    this._playNext := () => this.PlayNext()
    this._playPrevious := () => this.PlayPrevious()

    this.gui.BackColor := this.backColor
    this.gui.Opt("-Caption +AlwaysOnTop +E0x20 -SysMenu +ToolWindow -DPIScale")
    ; Gui(Font)
    this.gui.Add("Progress",
      " Vertical "
      " x" ((this.width - barWidth) / 2)
      " y" 20
      " w" (barWidth)
      " h" 80
      " vProgress"
      " c" this.barColor
      " +Background" this.barBackColor
    , this.currentVolume)
    this.gui.SetFont("c" this.fontColor " s8 w400")
    this.gui.Add("Text",
      " w" this.width
      " x" 0
      " Center"
      " vVolume",
      Integer(this.volume)
    )
    this.gui.Show(
      "NoActivate"
      " h" this.height
      " w" this.width
      (this.x == "" ? "" : " x" this.x)
      (this.y == "" ? "" : " y" this.y)
      , ""
    )

    WinSetTransparent(Trans, "ahk_id " this.gui.Hwnd)

    SetTimer(this._update, this.pollInterval)
    SetTimer(this._fade, "-" this.timeout)

    ; Register all the hotkeys
    for (action, keys in this.keys)
      for (index, key in keys)
        Hotkey(key, this["_" . action])
  }

  Fade() {
    While ( this.transparency > 0 && this.updating = 0) {
      this.transparency -= 2
      WinSetTransparent(this.transparency, "ahk_id " this.gui.Hwnd)
      Sleep(5)
    }
  }

  PlayNext() {
    ControlSend(">", , "- mpsyt")
  }

  PlayPause() {
    ControlSend(" ", , "- mpsyt")
  }

  PlayPrevious() {
    ControlSend("<", , "- mpsyt")
  }

  PlayStop() {
    ControlSend("{Control Down}c{Control Up}", , "- mpsyt")
  }

  Update() {
    this.volume := Integer(SoundGet())

    If (this.volume = this.currentVolume) {
      this.updating := 0
      if (this.updating == 1)
        SetTimer(this._update, this.pollInterval)
    } else {
      if (this.updating == 0)
        SetTimer(this._update, this.updateInterval)
      this.updating := 1

      this.gui.Control["Progress"].Value := Integer(this.volume)
      this.gui.Control["Volume"].Value := Integer(this.volume)
      this.currentVolume := this.volume

      While (this.transparency < this.maxTransparency) {
        this.transparency += 10
        WinSetTransparent(this.transparency, "ahk_id " this.gui.Hwnd)
        Sleep 1
      }

      SetTimer(this._fade, "-" this.timeout)
    }
  }

  VolumeDown() {
    SoundSet("-" this.amount)
    this.Update()
  }

  VolumeUp() {
    SoundSet("+" this.amount)
    this.Update()
  }
}

; #If ( mouseOverTray = 1 && overTray() )
; WheelDown::SoundSet("-" Amount, MASTER)
; WheelUp::SoundSet("+" Amount, MASTER)

; overTray() {
;   MouseGetPos(mX, mY, mWin)
;   WinGetClass(wClass, "ahk_id " mWin)
;   Return wClass = "Shell_TrayWnd" ? 1 : 0
; }
