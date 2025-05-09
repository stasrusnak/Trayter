#Requires AutoHotkey v1.1+
sourceWindowID := ""

; Ctrl+1 — сохраняем активное окно как источник, если оно WoW
^1::
    WinGet, activeID, ID, A
    WinGetClass, activeClass, ahk_id %activeID%
    if (activeClass = "GxWindowClass") {
        sourceWindowID := activeID
        MsgBox, Основное окно WoW сохранено!
    } else {
        MsgBox, Выбранное окно не является клиентом World of Warcraft!
    }
return

; Обработка клавиш 1-5, h и русской р
$1::
$2::
$3::
$4::
$5::
$h::
SC022::
    if (sourceWindowID = "")
        return

    WinGet, activeID, ID, A
    WinGetClass, activeClass, ahk_id %activeID%

    if (activeClass = "GxWindowClass") {
        if (activeID = sourceWindowID) {
            WinGet, idList, List, ahk_class GxWindowClass
            Loop, % idList {
                this_id := idList%A_Index%
                if (this_id != sourceWindowID) {
                    if (A_ThisHotkey = "SC022") {
                        ControlSend,, {SC022}, ahk_id %this_id%
                    } else {
                        key := SubStr(A_ThisHotkey, 2)
                        ControlSend,, %key%, ahk_id %this_id%
                    }
                    break
                }
            }
        }

        ; Нажимаем в текущем окне
        if (A_ThisHotkey = "SC022") {
            Send, {SC022}
        } else {
            Send, % SubStr(A_ThisHotkey, 2)
        }
    }
return

; Особая обработка средней кнопки мыши
$MButton::
    if (sourceWindowID = "")
        return

    WinGet, activeID, ID, A
    WinGetClass, activeClass, ahk_id %activeID%

    if (activeClass = "GxWindowClass" and activeID = sourceWindowID) {
        ; Ищем другое окно WoW
        WinGet, idList, List, ahk_class GxWindowClass
        Loop, % idList {
            this_id := idList%A_Index%
            if (this_id != sourceWindowID) {
                MouseGetPos, mx, my

                WinActivate, ahk_id %this_id%
                Sleep, 50
                Click Middle

                WinActivate, ahk_id %sourceWindowID%
                Sleep, 50
                MouseMove, %mx%, %my%, 0
                break
            }
        } 
        ; Нажимаем и в текущем окне
        Click Middle
    }
return
