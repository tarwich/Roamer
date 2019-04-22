#SingleInstance Force
#NoTrayIcon

; Note: You can optionally release CapsLock or the middle mouse button after
; pressing down the mouse button rather than holding it down the whole time.
; This script requires v1.0.25+.
new WindowDrag({
  prefix: "<!"
})

class WindowDrag {
  __New(options) {
    prefix := options.prefix

    this._beginDrag := () => this.BeginDrag()
    this._endDrag := () => this.EndDrag()
    this._step := () => this.Step()

    Hotkey(prefix "RButton", this._beginDrag)
    Hotkey(prefix "RButton UP", this._endDrag)
  }

  BeginDrag() {
    CoordMode("Mouse", "Screen")
    MouseGetPos(x, y, original)
    WinGetPos(windowX, windowY, windowWidth, windowHeight, "ahk_id " original)
    original := {
      x: windowX,
      y: windowY,
      width: windowWidth,
      height: windowHeight,
      hwnd: original
    }
    this.original := original
    this.xRegion := floor((x - original.x) / (original.width / 3))
    this.yRegion := floor((y - original.y) / (original.height / 3))
    this.beginX := x
    this.beginY := y
    SetTimer(this._step, 20)
  }

  EndDrag() {
    SetTimer(this._step, "Off")
    ToolTip()
  }

  Step() {
    CoordMode("Mouse", "Screen")
    MouseGetPos(x, y)
    diffX := x - this.beginX
    diffY := y - this.beginY
    original := this.original

    MonitorGetWorkArea(1, left, top, right, bottom)

    newX := this.original.x
    newY := this.original.y
    newWidth := this.original.width
    newHeight := this.original.height

    if (this.xRegion = 0) {
      newX := max(0, this.original.X + diffX)
      newWidth := this.original.width + (this.original.x - newX)
    }
    else if (this.xRegion = 1 and this.yRegion = 1)
      newX := min(right - newWidth, max(0, this.original.x + diffX))
    else if (this.xRegion = 2)
      newWidth := min(right - newX, this.original.width + diffX)

    if (this.yRegion = 0) {
      newY := max(0, this.original.y + diffY)
      newHeight := this.original.height + (this.original.y - newY)
    }
    else if (this.yRegion = 1 and this.xRegion = 1)
        newY := min(bottom - newHeight, max(0, this.original.y + diffY))
    else if (this.yRegion = 2)
      newHeight := min(bottom - newY, this.original.height + diffY)

    WinMove(newX, newY, newWidth, newHeight, "ahk_id " this.original.hwnd)
  }
}
