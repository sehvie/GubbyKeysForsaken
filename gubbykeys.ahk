IniRead, k1, gubbykeys.ini, Bindings, Key1, q
IniRead, k2, gubbykeys.ini, Bindings, Key2, e
IniRead, k3, gubbykeys.ini, Bindings, Key3, r
IniRead, k4, gubbykeys.ini, Bindings, Key4, t
sendKeys := [k1, k2, k3, k4]

bindsOn := false
temporarilyDisabled := false
currentKeyIndex := 1
gHeld := false

F1::
    bindsOn := !bindsOn
    temporarilyDisabled := false
    ToolTip % "toggled " (bindsOn ? "ON" : "OFF")
    SetTimer, RemoveTooltip, -1000
return

F2::
    currentKeyIndex := Mod(currentKeyIndex, sendKeys.MaxIndex()) + 1
    ToolTip % "pressing " sendKeys[currentKeyIndex]
    SetTimer, RemoveTooltip, -1000
return

F3::
    Gui, New
    Gui, Add, Text,, rebind:
    Loop, 4
        Gui, Add, Edit, vkey%A_Index% w50, % sendKeys[A_Index]
    Gui, Add, Button, gSaveKeys, Save
    Gui, Show,, Mouse1 Key Settings
return

SaveKeys:
	Loop, 4 {
		GuiControlGet, tempKey,, key%A_Index%
		if (tempKey = "")
			tempKey := sendKeys[A_Index]
		sendKeys[A_Index] := tempKey
		IniWrite, %tempKey%, gubbykeys.ini, Bindings, Key%A_Index%
	}
	currentKeyIndex := 1
	ToolTip, Key list saved!
	SetTimer, RemoveTooltip, -1000
	Gui, Destroy
return


~*g::
if (!gHeld && bindsOn) {
    gHeld := true
    Gosub, ToggleTemporaryDisable
}
return

~*g up::
gHeld := false
return

ToggleTemporaryDisable:
if (temporarilyDisabled) {
    temporarilyDisabled := false
    SetTimer, WaitForKey, Off
    ToolTip, Binds re-enabled
    SetTimer, RemoveTooltip, -1000
} else {
    temporarilyDisabled := true
    ToolTip, safe to emote
    SetTimer, RemoveTooltip, -3000
    SetTimer, WaitForKey, 10
}
return

~*LButton::
if (bindsOn && !temporarilyDisabled) {
    Send, % sendKeys[currentKeyIndex]
    return
}
return

~*MButton::
if (bindsOn && !temporarilyDisabled) {
    temporarilyDisabled := true
    SendEvent, {LButton}
    SetTimer, ReenableAfterMClick, -50
    return
}
return

ReenableAfterMClick:
temporarilyDisabled := false
return

WaitForKey:
if (GetKeyState("Space", "P") || GetKeyState("LButton", "P")) {
    temporarilyDisabled := false
    SetTimer, WaitForKey, Off
    ToolTip, re-enabled
    SetTimer, RemoveTooltip, -1000
}
return

RemoveTooltip:
ToolTip
return
