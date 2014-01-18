; initializing the script:
#SingleInstance force
#NoTrayIcon
#NoEnv
#KeyHistory 0
SetWorkingDir %A_ScriptDir%
#include %A_ScriptDir%\lib\Thumbnail.ahk

;--- Script to monitior a window or section of a window (such as a progress bar, or video) in a resizable live preview window

;--- This is an update (in terms of functionality) to the original livewindows ahk script by Holomind http://www.autohotkey.com/forum/topic11588.html
;--- which takes advantage of windows vista/7 Aeropeak. The script relies on Thumbnail.ahk, a great script by relmaul.esel, http://www.autohotkey.com/forum/topic70839.html
;--------------------------------------------------------------------------------------------

Hotkey, #^+LButton , start_defining_region
Hotkey, #w, watchWindow


; msgbox, Press win+w to watch the entire active window `n`nOr hold down ctrl+shift and drag a box around the `narea you are interested in to watch a specific region
return

;--------------------------------------------------------------------------------------------

watchWindow:

   WinGetClass, class, A    ; get ahk_id of foreground window
   targetName = ahk_class %class%  ; get target window id
   WinGetPos, , , Rwidth, Rheight, A
   start_x := 0
   start_y := 0
   sleep, 500   
      
   ThumbWidth := 400
   ThumbHeight := 400
   thumbID := mainCode(targetName,ThumbWidth,ThumbHeight,start_x,start_y,Rwidth,Rheight)
   
return

start_defining_region:


      Gui, Destroy  
      Thumbnail_Destroy(thumbID)

   CoordMode, Mouse, Relative                ; relative to window not screen
   MouseGetPos, start_x, start_y             ; start position of mouse
   SetTimer end_defining_region, 200                        ; check every 50ms for mouseup
   
   
Return

end_defining_region:
   
   ; get the region dimensions
   MouseGetPos, current_x, current_y 
   
   Rheight := abs(current_y - start_y)
   Rwidth := abs(current_x - start_x)
   
   WinGetPos, win_x, win_y, , , A
   
   P_x := start_x + win_x
   P_y := start_y + win_y
   
   if (current_x < start_x)
       P_x := current_x + win_x

   if (current_y < start_y)
       P_y := current_y + win_y
     
   ; draw a box to show what is being defined
   Progress, B1 CWffdddd CTff5555 ZH0 fs13 W%Rwidth% H%Rheight% x%P_x% y%P_y%, , ,getMyRegion
   WinSet, Transparent, 110, getMyRegion
  
  ; if mouse not released then loop through above code...
   If GetKeyState("LButton", "P")
      Return
    
   ;...otherwise, stop defining region, and start thumbnail ------------------------------->
   SetTimer end_defining_region, OFF
      
   Progress, off
      
   MouseGetPos, end_x, end_y
   if (end_x < start_x)
       start_x := end_x

   if (end_y < start_y)
       start_y := end_y
     
   WinGetClass, class, A    ; get ahk_id of foreground window

   targetName = ahk_class %class%  ; get target window id
  
  
   sleep, 500
   ThumbWidth := Rwidth
   ThumbHeight := Rheight
   thumbID := mainCode(targetName,ThumbWidth,ThumbHeight,start_x,start_y,Rwidth,Rheight)

return



mainCode(targetName,windowWidth,windowHeight,RegionX,RegionY,RegionW,RegionH)
{
; get the handles:
Gui +LastFound
hDestination := WinExist() ; ... to our GUI...
hSource := WinExist(targetName) ;

; creating the thumbnail:
hThumb := Thumbnail_Create(hDestination, hSource) ; you must get the return value here!

; getting the source window dimensions:
Thumbnail_GetSourceSize(hThumb, width, height)

  ;-- make sure ratio is correct
  CorrectRatio := RegionW / RegionH
  testWidth := windowHeight * CorrectRatio
  if (windowWidth <  testWidth)
  {
     windowHeight := windowWidth / CorrectRatio
  }
;  else
;  {
;     windowWidth := testWidth
;  }
  

; then setting its region:
Thumbnail_SetRegion(hThumb, 0, 0 , windowWidth, windowHeight, RegionX , RegionY ,RegionW, RegionH)



; now some GUI stuff:
Gui +AlwaysOnTop +ToolWindow +Resize 

; Now we can show it:
Thumbnail_Show(hThumb) ; but it is not visible now...
Gui Show, w%windowWidth% h%windowHeight%, Live Thumbnail ; ... until we show the GUI
OnMessage(0x201, "WM_LBUTTONDOWN")


return hThumb
}


GuiSize:
  ;if ErrorLevel = 1  ; The window has been minimized.  No action needed.
  ;  return
  
 Thumbnail_Destroy(thumbID)
  ThumbWidth := A_GuiWidth
  ThumbHeight := A_GuiHeight
 thumbID := mainCode(targetName,ThumbWidth,ThumbHeight,start_x,start_y,Rwidth,Rheight)
return

;----------------------------------------------------------------------

GuiClose: ; in case the GUI is closed:
  Thumbnail_Destroy(thumbID) ; free the resources
ExitApp


WM_LBUTTONDOWN(wParam, lParam)
{
    mX := lParam & 0xFFFF
    mY := lParam >> 16
    SendClickThrough(mX,mY)
}

SendClickThrough(mX,mY)
{
  global 
  
  convertedX := Round((mX / ThumbWidth)*Rwidth + start_x)
  convertedY := Round((mY / ThumbHeight)*Rheight + start_y)
  ;msgBox, x%convertedX% y%convertedY%, %targetName%
  ControlClick, x%convertedX% y%convertedY%, %targetName%,,,, NA
;  sleep, 250
;  ControlClick, x%convertedX% y%convertedY%, %targetName%,,,, NA u
}



