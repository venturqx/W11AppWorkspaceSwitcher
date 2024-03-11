; CREDIT : https://github.com/gaulinmp/AutoHotKey/
; CREDIT : https://www.youtube.com/watch?v=BMI5ZGLWWvw&pp=ugMICgJpdBABGAHKBQxhbHQgZHJhZyBhaGs%3D
; CREDIT : https://github.com/andreapizzigoni/altdrag_ahk
; CREDIT : https://github.com/Ciantic/VirtualDesktopAccessor
; CREDIT : https://github.com/TaranVH/2nd-keyboard/blob/master/Almost_All_Windows_Functions.ahk
; CREDIT : https://gist.github.com/jcsteh/7ccbc6f7b1b7eb85c1c14ac5e0d65195
; CREDIT : https://gist.github.com/mariotacke/5d3e530b554fae7b6d0d9fb2b3292a37?permalink_comment_id=4763109

; Pour du regex .*Keyword
SetTitleMatchMode, Regex
SetTitleMatchMode, Slow

; Explorer-based "save" and "load" boxes, from any program, as ExplorerGroup member
GroupAdd, ExplorerGroup, ahk_class #32770 

; Recommended for new scripts due to its superior speed and reliability. (?)
SendMode Input  

numlock := true
focusDelay := 20

;SECTION - Workspace
VDA_PATH := "C:\Users\tungsten\Prog\capsicain\VirtualDesktopAccessor.dll"
hVirtualDesktopAccessor := DllCall("LoadLibrary", "Str", VDA_PATH, "Ptr")
GetDesktopCountProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "GetDesktopCount", "Ptr")
GoToDesktopNumberProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "GoToDesktopNumber", "Ptr")
GetCurrentDesktopNumberProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "GetCurrentDesktopNumber", "Ptr")
IsWindowOnCurrentVirtualDesktopProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "IsWindowOnCurrentVirtualDesktop", "Ptr")
IsWindowOnDesktopNumberProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "IsWindowOnDesktopNumber", "Ptr")
MoveWindowToDesktopNumberProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "MoveWindowToDesktopNumber", "Ptr")
IsPinnedWindowProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "IsPinnedWindow", "Ptr")
GetDesktopNameProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "GetDesktopName", "Ptr")
SetDesktopNameProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "SetDesktopName", "Ptr")
CreateDesktopProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "CreateDesktop", "Ptr")
RemoveDesktopProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "RemoveDesktop", "Ptr")
RegisterPostMessageHookProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "RegisterPostMessageHook", "Ptr")
UnregisterPostMessageHookProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "UnregisterPostMessageHook", "Ptr")


GetDesktopCount() {
    global GetDesktopCountProc
    count := DllCall(GetDesktopCountProc, "Int")
    return count    
}

MoveToDesktop(desktopNumber) {
    global MoveWindowToDesktopNumberProc, GoToDesktopNumberProc
    WinGet, activeHwnd, ID, A
    DllCall(MoveWindowToDesktopNumberProc, "Ptr", activeHwnd, "Int", desktopNumber, "Int")
}

MoveAndGoToDesktop(desktopNumber) {
    global MoveWindowToDesktopNumberProc, GoToDesktopNumberProc
    WinGet, activeHwnd, ID, A
    DllCall(MoveWindowToDesktopNumberProc, "Ptr", activeHwnd, "Int", desktopNumber, "Int")
    DllCall(GoToDesktopNumberProc, "Int", desktopNumber)
}

GoToPrevDesktop() {
    global GetCurrentDesktopNumberProc, GoToDesktopNumberProc
    current := DllCall(GetCurrentDesktopNumberProc, "Int")
    last_desktop := GetDesktopCount() - 1
    if (current = 0) {
        GoToDesktopNumber(last_desktop)
    } else {
        GoToDesktopNumber(current - 1)
    }
    return
}

GoToNextDesktop() {
    global GetCurrentDesktopNumberProc, GoToDesktopNumberProc
    current := DllCall(GetCurrentDesktopNumberProc, "Int")
    last_desktop := GetDesktopCount() - 1
    if (current = last_desktop) {
        GoToDesktopNumber(0)
    } else {
        GoToDesktopNumber(current + 1)
    }
    return
}

MoveAndGoToPrevDesktop() {
    global GetCurrentDesktopNumberProc, GoToDesktopNumberProc
    current := DllCall(GetCurrentDesktopNumberProc, "Int")
    last_desktop := GetDesktopCount() - 1
    if (current = 0) {
        MoveAndGoToDesktop(last_desktop)
    } else {
        MoveAndGoToDesktop(current - 1)
    }
    return
}

MoveAndGoToNextDesktop() {
    global GetCurrentDesktopNumberProc, GoToDesktopNumberProc
    current := DllCall(GetCurrentDesktopNumberProc, "Int")
    last_desktop := GetDesktopCount() - 1
    if (current = last_desktop) {
        MoveAndGoToDesktop(0)
    } else {
        MoveAndGoToDesktop(current + 1)
    }
    return
}

MoveToPrevDesktop() {
    global GetCurrentDesktopNumberProc, GoToDesktopNumberProc
    current := DllCall(GetCurrentDesktopNumberProc, "Int")
    last_desktop := GetDesktopCount() - 1
    if (current = 0) {
        MoveToDesktop(last_desktop)
    } else {
        MoveToDesktop(current - 1)
    }
    return
}

MoveToNextDesktop() {
    global GetCurrentDesktopNumberProc, GoToDesktopNumberProc
    current := DllCall(GetCurrentDesktopNumberProc, "Int")
    next_desktop := GetDesktopCount() + 1
    if (current = last_desktop) {
        MoveToDesktop(0)
    } else {
        MoveToDesktop(current + 1)
    }
    return
}

GoToDesktopNumber(num) {
    global GoToDesktopNumberProc
    DllCall(GoToDesktopNumberProc, "Int", num, "Int")
    return
}

MoveOrGotoDesktopNumber(num) {
    if (GetKeyState("LShift")) {
        MoveToDesktop(num)
    } else {
        GoToDesktopNumber(num)
    }
    return
}

GetDesktopName(num) {
    global GetDesktopNameProc
    utf8_buffer := ""
    utf8_buffer_len := VarSetCapacity(utf8_buffer, 1024, 0)
    ran := DllCall(GetDesktopNameProc, "Int", num, "Ptr", &utf8_buffer, "Ptr", utf8_buffer_len, "Int")
    name := StrGet(&utf8_buffer, 1024, "UTF-8")
    return name
}

SetDesktopName(num, name) {
    global SetDesktopNameProc
    VarSetCapacity(name_utf8, 1024, 0)
    StrPut(name, &name_utf8, "UTF-8")
    ran := DllCall(SetDesktopNameProc, "Int", num, "Ptr", &name_utf8, "Int")
    return ran
}

CreateDesktop() {
    global CreateDesktopProc
    ran := DllCall(CreateDesktopProc)
    return ran
}

RemoveDesktop(remove_desktop_number, fallback_desktop_number) {
    global RemoveDesktopProc
    ran := DllCall(RemoveDesktopProc, "Int", remove_desktop_number, "Int", fallback_desktop_number, "Int")
    return ran
}

DllCall(RegisterPostMessageHookProc, "Ptr", A_ScriptHwnd, "Int", 0x1400 + 30, "Int")
OnMessage(0x1400 + 30, "OnChangeDesktop")
OnChangeDesktop(wParam, lParam, msg, hwnd) {
    Critical, 100
    OldDesktop := wParam + 1
    NewDesktop := lParam + 1
    Name := GetDesktopName(NewDesktop - 1)
    OutputDebug % "Desktop changed to " Name " from " OldDesktop " to " NewDesktop
}

; Shortcut : Physics => Capsicain => AHK 
F17 & 0:: 
    GoToDesktopNumber(0)
    Sleep 20
    focusWinUnderCursor()
return

F17 & 1:: 
    GoToDesktopNumber(1)
    Sleep 20
    focusWinUnderCursor()
return

F17 & 2:: 
    GoToDesktopNumber(2)
    Sleep 20
    focusWinUnderCursor()
return

F17 & 3:: 
    GoToDesktopNumber(3)
    Sleep 20
    focusWinUnderCursor()
return
    
F17 & 4:: 
    GoToDesktopNumber(4)
    Sleep 20
    focusWinUnderCursor()
return
F17 & 5:: 
    GoToDesktopNumber(5)
    Sleep 20
    focusWinUnderCursor()
return
F17 & 6:: 
    GoToDesktopNumber(6)
    Sleep 20
    focusWinUnderCursor()
return

F17 & 7:: 
    GoToDesktopNumber(7)
    Sleep 20
    focusWinUnderCursor()
return

F17 & 8:: 
    GoToDesktopNumber(8)
    Sleep 20
    focusWinUnderCursor()
return

F17 & 9:: 
    GoToDesktopNumber(9)
    Sleep 20
    focusWinUnderCursor()
return

F17 & Q:: 
    MoveAndGoToDesktop(0)
    Sleep 20
    focusWinUnderCursor()
return

F17 & W:: 
    MoveAndGoToDesktop(1)
    Sleep 20
    focusWinUnderCursor()
return

F17 & E:: 
    MoveAndGoToDesktop(2)
    Sleep 20
    focusWinUnderCursor()
return

F17 & R:: 
    MoveAndGoToDesktop(3)
    Sleep 20
    focusWinUnderCursor()
return

F17 & T:: 
    MoveAndGoToDesktop(4)
    Sleep 20
    focusWinUnderCursor()
return

F17 & Y:: 
    MoveAndGoToDesktop(5)
    Sleep 20
    focusWinUnderCursor()
return

F17 & U:: 
    MoveAndGoToDesktop(6)
    Sleep 20
    focusWinUnderCursor()
return

F17 & I:: 
    MoveAndGoToDesktop(7)
    Sleep 20
    focusWinUnderCursor()
return

F17 & O:: 
    MoveAndGoToDesktop(8)
    Sleep 20
    focusWinUnderCursor()
return

F17 & P:: 
    MoveAndGoToDesktop(9)
    Sleep 20
    focusWinUnderCursor()
return

F17 & A:: 
    MoveToDesktop(0)
    Sleep 20
    focusWinUnderCursor()
return

F17 & S:: 
    MoveToDesktop(1)
    Sleep 20
    focusWinUnderCursor()
return

F17 & D:: 
    MoveToDesktop(2)
    Sleep 20
    focusWinUnderCursor()
return

F17 & F:: 
    MoveToDesktop(3)
    Sleep 20
    focusWinUnderCursor()
return

F17 & G:: 
    MoveToDesktop(4)
    Sleep 20
    focusWinUnderCursor()
return

F17 & H:: 
    MoveToDesktop(5)
    Sleep 20
    focusWinUnderCursor()
return

F17 & J:: 
    MoveToDesktop(6)
    Sleep 20
    focusWinUnderCursor()
return

F17 & K:: 
    MoveToDesktop(7)
    Sleep 20
    focusWinUnderCursor()
return

F17 & L:: 
    MoveToDesktop(8)
    Sleep 20
    focusWinUnderCursor()
return

F17 & SC027::
    MoveToDesktop(9)
    Sleep 20
    focusWinUnderCursor()
return

F17 & Z::
    GoToPrevDesktop()
    Sleep 20
    focusWinUnderCursor()
return

F17 & X:: GoToNextDesktop()
    Sleep 20
    focusWinUnderCursor()
return

; LAlt & LButton::
;     if(GetKeyState("LShift", "P"))
;         MoveAndGoToPrevDesktop()
;     else
;         GoToPrevDesktop()
;     focusWinUnderCursor()
; return

; LAlt & RButton::
;     if(GetKeyState("LShift", "P"))
;         MoveAndGoToNextDesktop()
;     else
;         GoToNextDesktop()
;     focusWinUnderCursor()
; return


focusWinUnderCursor() {
    MouseGetPos, win_x, win_y, win_id	
    WinGet, win_x, MinMax, % "ahk_id " win_id
    if (win_x < 0)  ; Si la fenêtre est minimisée
        WinRestore, % "ahk_id " win_id  ; Restaurer la fenêtre
    WinActivate, % "ahk_id " win_id  ; Activer la fenêtre
}
;!SECTION



;SECTION Misc 

F18 & O::Run, explorer.exe "C:\Users\tungsten\Desktop"

F18 & B::
    WinGet, spotifyHwnd, ID, ahk_exe Spotify.exe
	WinGet, style, Style, ahk_id %spotifyHwnd%
	if (style & 0x10000000) { ; WS_VISIBLE
		WinHide, ahk_id %spotifyHwnd%
        MouseMove, %OrigX%, %OrigY%  ; Revenir à la position initiale de la souris
	} Else {
		WinShow, ahk_id %spotifyHwnd%
		WinActivate, ahk_id %spotifyHwnd%
        MouseGetPos, OrigX, OrigY  ; Retenir la position actuelle de la souris
        MouseMove, 218, 1004       ; Déplacer la souris à la position spécifiée    
	}
return

;Ctrl & Numpad 4: Previous Track
#Numpad4::Media_Prev

;Ctrl & Numpad 6: Next Track
#Numpad6::Media_Next

;Ctrl & Numpad 8: Volume Up
#Numpad8::SoundSet +3

;Ctrl & Numpad 2: Volume Down
#Numpad2::SoundSet -3

;Ctrl & Numpad 5: Play/Pause Track
#Numpad5::Media_Play_Pause

#Numpad1::
  AdjustScreenBrightness(-3)
  Return
  
#Numpad7::
  AdjustScreenBrightness(3)
  Return


  
AdjustScreenBrightness(step) {
    service := "winmgmts:{impersonationLevel=impersonate}!\\.\root\WMI"
    monitors := ComObjGet(service).ExecQuery("SELECT * FROM WmiMonitorBrightness WHERE Active=TRUE")
    monMethods := ComObjGet(service).ExecQuery("SELECT * FROM wmiMonitorBrightNessMethods WHERE Active=TRUE")
    minBrightness := 5  ; level below this is identical to this

    for i in monitors {
        curt := i.CurrentBrightness
        break
    }
    if (curt < minBrightness)  ; parenthesis is necessary here
        curt := minBrightness
    toSet := curt + step
    if (toSet > 100)
        return
    if (toSet < minBrightness)
        toSet := minBrightness
        
    

    for i in monMethods {
        i.WmiSetBrightness(1, toSet)
        break
    }
}

; Alt = Mouse
AltPressed := false
~F21::
	if (!AltPressed) {
		AltPressed := true
		Click down
	}
return

~F21 up::
	if (AltPressed) {
		Click up
		AltPressed := false
	}
return

; LWin + j = Wifi
F17 & V up::
    Send, {LWin down}a{LWin up}
	Sleep, 1100
	Send, {Tab}{Enter}
return

; LWin + k = Blutooth  
F17 & PgUp up::
    Sleep, 50
    Send, {LWin down}a{LWin up}
	Sleep, 1000
    Send, {Right}
    Sleep, 50
    Send, {Tab}
    Sleep, 50
    Send, {Enter}
    Sleep, 800
    Send, {Tab}
return

; VSCode Anchor
F17 & B::
    Send, ^k
    Send, ^m
return

; < > ( ) { } [ ] |
LCtrl & ,::Send, {(}
LCtrl & `;::Send, {)}
LAlt & ,::Send, {{}
LAlt & `;::Send, {}}
LWin & ,::Send, {[}
LWin & `;::Send, {]}
RAlt & ,::Send, {<}
RAlt & `;::Send, {>}
LShift & !::Send, {|}

; Windows Notification
;#Esc::#n

;F18 & q::Run, "C:\Users\tungsten\Prog\capsicain\startMenu.vbs"


;!SECTION


;SECTION - App switcher
windows0=[]
windows1=[]
windows2=[]
windows3=[]
windows4=[]
windows5=[]
windows6=[]
windows7=[]
windows8=[]
windows9=[]

F18 & U::
IfWinNotExist, ahk_exe stm32cubeide.exe
	if (A_PriorHotKey = A_ThisHotKey && A_TimeSincePriorHotkey < 200)
		Run, "C:\ST\STM32CubeIDE_1.14.1\STM32CubeIDE\stm32cubeide.exe", UseErrorLevel
WinGet, activeProcessName, ProcessName, A
if (activeProcessName = "stm32cubeide.exe")
{
	; IfWinNotExist, ahk_exe STM32CubeMonitor.exe
	; 	Run, "C:\Users\tungsten\AppData\Local\STM32CubeMonitor\STM32CubeMonitor.exe", UseErrorLevel
	; else 
		WinActivate ahk_exe STM32CubeMonitor.exe
	main5:=false
} else if (activeProcessName = "STM32CubeMonitor.exe") {
	WinActivate ahk_exe stm32cubeide.exe
	main5:=true
} else if main5 {
	IfWinExist, ahk_exe stm32cubeide.exe
		WinActivate ahk_exe stm32cubeide.exe
		main5:=true
} else {
	IfWinExist, ahk_exe STM32CubeMonitor.exe
	{
		WinActivate ahk_exe STM32CubeMonitor.exe
		main5:=false
	} else {
		WinActivate ahk_exe stm32cubeide.exe
		main5:=true
	}
}
return 


; Windows Terminal
F18 & I::
    if (numlock) {
        WinGetClass, activeClass, A
        if (activeClass = "CASCADIA_HOSTING_WINDOW_CLASS") {
            windows0 := []
            WinGet, idList, List
            Loop, %idList%
            {
                thisID := idList%A_Index%
                WinGetTitle, thisTitle, ahk_id %thisID%
                if (thisTitle = "Terminal")
                {
                    windows0.Push(thisID)  
                }
            }
            WinGetClass, activeClass, A
            if (activeClass = "CASCADIA_HOSTING_WINDOW_CLASS") {
                ; cycle
                maxIndex := windows0.MaxIndex()
                thisID := windows0[maxIndex]
            } else
                ; last
                thisID := windows0[1]
            WinActivate, ahk_id %thisID%
        } else {
            WinActivate, ahk_class CASCADIA_HOSTING_WINDOW_CLASS
        }
    } else {
        Send, 0
    }
return

; Google Chrome (except ChatGPT) 
F18 & Q::
if (numlock) {
    windows1 := []
    WinGet, idList, List  
    Loop, %idList%
    {
        thisID := idList%A_Index%
        WinGetTitle, thisTitle, ahk_id %thisID%
        ; if (InStr(thisTitle, "- Google Chrome") && (!InStr(thisTitle, "@GPT") || !InStr(thisTitle, "Anthropic Console"))) {
        if (InStr(thisTitle, "- Google Chrome") && !((InStr(thisTitle, "@GPT") || InStr(thisTitle, "Anthropic Console"))) ) {
            windows1.Push(thisID)
        }
    }
    if (windows1[1] = "") { 
        if (activeProcessName = "FluentSearch.exe") {
            Send, {Escape}
        } else {
            Send, {F19}
        }
        ; if (A_PriorHotKey = A_ThisHotKey && A_TimeSincePriorHotkey < 200)
        ;     Run, "chrome.exe", UseErrorLevel	
    } else { ; il y a déjà >=1 chrome
        WinGetTitle, activeTitle, A
        maxIndex := windows1.MaxIndex()
        ; ToolTip, % " " maxIndex
        if (InStr(activeTitle, "Google") && !(InStr(activeTitle, "@GPT") || InStr(activeTitle, "Anthropic Console")) ) {
            if (maxIndex = 1) {
                ;Send, ^{Tab}
            } else {
                ; cycle
                thisID := windows1[maxIndex]
                WinActivate, ahk_id %thisID%
            }
        } else {
            ; last
            thisID := windows1[1]
            WinActivate, ahk_id %thisID%
        }
    }
} else {
    Send, 1
}
return

; ChatGPT
F18 & G::
if (numlock) {    
    WinGetTitle, thisTitle, ahk_id %thisID%
    WinGet, activeProcessName, ProcessName, A
    if ((InStr(thisTitle, "@GPT") || InStr(thisTitle, "Anthropic Console")) && (activeProcessName = "chrome.exe"))
    {
        ; Toast2("true")
        Send, ^{Tab}
        Sleep, 20
        Click, 1463, 993
    } else {
        found := false
        WinGet, idList, List
        Loop, %idList%
        {
            thisID := idList%A_Index%
            WinGetTitle, thisTitle, ahk_id %thisID%
            WinGet, ProcessName, ProcessName, ahk_id %thisID%
            if ((InStr(thisTitle, "@GPT") && ProcessName != "Obsidian.exe"))
            {
                WinActivate, ahk_id %thisID%
                Sleep, 20
                Click, 1463, 993
                found := true
                break
            }
            else if InStr(thisTitle, "Anthropic Console")
            {
                WinActivate, ahk_id %thisID%
                Sleep, 20
                Click, 1095, 358
                found := true
                break
            }    
        }
        if (!found) {
            if (A_PriorHotKey = A_ThisHotKey && A_TimeSincePriorHotkey < 200) {
                Run chrome.exe "https://chat.openai.com/" " --new-window "
                Sleep, 1900
                Click, 1463, 993
            }	
        }
    }
}
return

; VSCode
shift3:=false
F18 & E::
if (numlock) {
    IfWinNotExist, ahk_exe Code.exe
    {
        ; WinGetTitle, activeTitle, A
        ; if (InStr(activeTitle, "Fluent Search") > 0) {
        ;     Send, {Esc}
        ; } else {
        ;     Send, {F19}
        ;     Sleep, 80
        ;     Send, .code-workspace
        ; }
        WinGet, activeProcessName, ProcessName, A
        if (activeProcessName = "FluentSearch.exe") {
            Send, {Escape}
        } else {
            Send, {F19}
        }
    } else {
        windows3 := []
        WinGet, idList, List  ; Obtient une liste de toutes les fenêtres
        Loop, %idList%
        {
            thisID := idList%A_Index%
            WinGetTitle, thisTitle, ahk_id %thisID%
            if ((InStr(thisTitle, "- Visual Studio Code") > 0) || (InStr(thisTitle, "Device Simulator") > 0))
                windows3.Push(thisID)
        }
        WinGetTitle, activeTitle, A
        if ((InStr(activeTitle, "- Visual Studio Code") > 0) || (InStr(activeTitle, "Device Simulator") > 0)) {
            ; cycle
            maxIndex := windows3.MaxIndex()
            thisID := windows3[maxIndex]
            if (maxIndex=1){
                    ;Send, ^{Tab}
                return
            } 
        } else {
            ; last
            thisID := windows3[1]
        }
        WinActivate, ahk_id %thisID%  ; Déplace le focus sur la fenêtre de Visual Studio Code
    }
} else {
    Send, 3
}
return

; Explorer
F18 & R::
if (numlock) {
        
    IfWinNotExist ahk_class CabinetWClass
    {
        ; WinGet, activeProcessName, ProcessName, A
        ; if (activeProcessName = "FluentSearch.exe") {
        ;     Send, {Escape}
        ; } else {
        ;     Send, {F19}
        ; }
        Run, explorer.exe "C:\Users\tungsten\Desktop"
    } else {
        GroupAdd, groupExplorer, ahk_class CabinetWClass
        if WinActive("ahk_exe explorer.exe")
            GroupActivate, groupExplorer, r
        else
            WinActivate ahk_class CabinetWClass ;you have to use WinActivatebottom if you didn't create a window group.
    }
} else {
    ;Send, {LWin down} {Numpad4} {LWin up}
}
return

; Shift + NP3 
F17 & N::Send, ^+{Tab}

; Obsidian
toggleNP5=true;
F18 & W::
if (numlock) {
    WinGet, activeProcessName, ProcessName, A
    IfWinNotExist, ahk_exe Obsidian.exe
    {
        if (A_PriorHotKey = A_ThisHotKey && A_TimeSincePriorHotkey < 200) {
            Run, "C:\Users\tungsten\AppData\Local\Programs\obsidian\Obsidian.exe", UseErrorLevel
        }
    } else {
        WinGet, activeProcessName, ProcessName, A
        if (activeProcessName = "Obsidian.exe") {
            toggleNP5 := !toggleNP5
            if (toggleNP5 = true) {
                Send ^j
                MouseMove, 990, 490
            } else {
                Send ^m
                MouseMove, 1110, 490
            }
        } else
            WinActivate ahk_exe Obsidian.exe
        }
} else {
    Send, 5
}
return 
	
; Outlook
F18 & T::
if (numlock) {
        
    IfWinNotExist, ahk_exe olk.exe
        Run, "olk.exe", UseErrorLevel
    else {
        windows6 := []
        WinGet, idList, List
        Loop, %idList%
        {
            thisID := idList%A_Index%
            WinGet, thisProcess, ProcessName, ahk_id %thisID%
            if (thisProcess = "olk.exe")
                windows6.Push(thisID)
        }
        WinGet, activeProcessName, ProcessName, A
        if (activeProcessName = "olk.exe") {
            ; cycle
            maxIndex := windows6.MaxIndex()
            thisID := windows6[maxIndex]
        } else
            thisID := windows6[1]
        WinActivate, ahk_id %thisID%
    }
} else {
    Send, 7
}
return

; Reload
LAlt & Numpad9::
if (numlock) {
    reload
} else {
    Send, 9
}
return

; Add action
F18 & A::
if (numlock) {
    
    WinGetClass, activeClass, A
    if (activeClass = "CASCADIA_HOSTING_WINDOW_CLASS") {
        Send, +^t
    } else if (activeClass = "CabinetWClass") {
        Send, ^n
    } else {
        WinGet, activeProcessName, ProcessName, A
        if (activeProcessName = "Code.exe") {
            Send, ^e
        } else if (activeProcessName = "Obsidian.exe") {
            Send, ^t
        } else if (activeProcessName = "chrome.exe") {
            WinGetTitle, thisTitle, ahk_id %thisID%
            if (InStr(thisTitle, "Google") && InStr(thisTitle, "@GPT")) {
                Send, ^t
                Sleep, 20
                Send, chat.openai.com{Enter}
                Sleep, 1600
                Click, 1463, 993		
            } else
                Send, ^t
        } else {
                Send, ^t
        }
    }
} else {
    Send, {+}
}
return

; Alt add
F18 & S::
WinGet, activeProcessName, ProcessName, A
if (activeProcessName = "Code.exe") {
	Send, {F19}
	Sleep 30
	Send, .code-workspace
} else { ;if (activeProcessName = "Obsidian.exe") {
	Send, ^n
}
return

; Delete
F18 & D::
if (numlock) {
    WinGet, activeProcessName, ProcessName, A
    if (activeProcessName = "WindowsTerminal.exe") {
        Send, ^+w
    } else {
        Send, ^w
    }
} else {
    Send, -
}
return

; Alt delete
F18 & F::
WinGet, activeProcessName, ProcessName, A
if (activeProcessName = "Obsidian.exe") {
	Send, ^+d
}else if (activeProcessName = "Code.exe") {
	Send, ^+w
} else {
	Send, !{F4}
}
return

; Launch_Media::
;     numlock := !numlock
; return

; Close
;!NumpadSub::!F4

; Alt Enter = Post GPT @edit
!Enter::
WinGetTitle, activeTitle, A
if (InStr(activeTitle, "Google") && InStr(activeTitle, "@GPT"))
	Send, #!{Enter}
return

;; NUMPAD + SHIFT
; NumpadIns::0
; NumpadEnd::1
; NumpadDown::2
; NumpadPgDn::^Tab
; NumpadLeft::4
; NumpadClear::5
; NumpadRight::6
; NumpadHome::7
; NumpadUp::8
; NumpadPgUp::9
; NumpadDel::.

;!SECTION



; SECTION - Utility
Toast(label, msg) {
    #Persistent
    #SingleInstance, Force
    Gui, +ToolWindow -Caption +AlwaysOnTop +Disabled
    Gui, Color, 000000

    Gui, Font, cFFFFFF S14, Verdana    
    Gui, add, Text, center x0 w200 h28 y20 , %msg%

    Gui, Font, cFFFFFF S18, Verdana
    Gui, add, Text, center x0 w200 h28 y50, %label%
    
    Gui, Show, H100 W200 NoActivate, Output
    
    WinSet, Region, 0-0 H100 W200 R30-30, Output
    WinSet, ExStyle, +0x20, Output
    WinSet, Transparent, 200, Output
    TransFade := 200
    
    Sleep,600
    Loop,25
     {
      TransFade := TransFade - 12
      WinSet, Transparent, %TransFade%, Output
      Sleep 1
     }
    Gui, Destroy
    return
    }

Toasty(data1:="",data2:="",data3:="",data4:="",data5:="",data6:="",data7:="",data8:="",data9:="",data10:="") {
	ToolTip % "" data1 " | " data2 " | " data3 " | " data5 " | " data6 " | " data7 " | " data8 " | "  data9 " | "  data10 " | "
}
;!SECTION