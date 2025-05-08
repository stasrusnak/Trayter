#Requires AutoHotkey v1.1+
sourceWindowID := ""

; Ctrl+1 — сохраняем активное окно как источник, но только если это окно WoW
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

; Дублируем клавиши 1-5, h, русскую р и среднюю кнопку мыши
$1::
$2::
$3::
$4::
$5::
$h::
SC022::
$MButton::
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
                    ; Сохраняем положение мыши
                    MouseGetPos, mx, my, originalWin

                    ; Активируем второе окно
                    WinActivate, ahk_id %this_id%
                    Sleep, 50  ; подождать активации

                    Click Middle

                    ; Возвращаем фокус на исходное окно
                    WinActivate, ahk_id %sourceWindowID%
                    Sleep, 50

                    ; Возвращаем курсор в исходную позицию
                    MouseMove, %mx%, %my%, 0

                    break
                }
            }
        }

        ; Также нажимаем среднюю кнопку в основном окне
        Send, {MButton}
    }
return

