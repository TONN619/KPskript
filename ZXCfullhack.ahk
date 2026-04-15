#Persistent
SetTitleMatchMode, 2
CoordMode, ToolTip, Screen

; --- Глобальные настройки ---
ShowTooltips := true
AutoSpaceEnabled := false
AutoERunning := false
LagSwitchEnabled := false

; === Таблица горячих клавиш при запуске ===
ShowHotkeysTable()
SetTimer, RemoveToolTip, -5000

ShowHotkeysTable() {
    ToolTip,
    (LTrim
    ===== Горячие клавиши =====
    F1 - Автопробел
    F2 - Авто-E
    F3 - Подсказки ВКЛ/ВЫКЛ
    F4 - Lag Switch (Вкл/Выкл интернет)
    ===========================
    ), 10, 10
}

; === Горячие клавиши ===

; F1 - Автопробел
F1::
    AutoSpaceEnabled := !AutoSpaceEnabled
    Gosub, ShowF1Status
return

ShowF1Status:
    if (ShowTooltips) {
        status := AutoSpaceEnabled ? "ВКЛЮЧЕН" : "ВЫКЛЮЧЕН"
        ToolTip, Автопробел %status%, 10, 30
        SetTimer, RemoveToolTip, 2000
    }
return

; F2 - Авто-E
F2::
    AutoERunning := !AutoERunning
    Gosub, ShowF2Status
    if (AutoERunning) {
        SetTimer, SpamE, 50
    } else {
        SetTimer, SpamE, Off
    }
return

ShowF2Status:
    if (ShowTooltips) {
        status := AutoERunning ? "ВКЛЮЧЕН" : "ВЫКЛЮЧЕН"
        ToolTip, Авто-E %status%, 10, 50
        SetTimer, RemoveToolTip, 2000
    }
return

; F3 - Управление подсказками
F3::
    ShowTooltips := !ShowTooltips
    Gosub, ShowF3Status
return

ShowF3Status:
    status := ShowTooltips ? "ВКЛЮЧЕНЫ" : "ВЫКЛЮЧЕНЫ"
    ToolTip, Подсказки %status%, 10, 70
    SetTimer, RemoveToolTip, 2000
return

; ========= LAG SWITCH НА F4 =========
; Отключает и включает интернет по нажатию
F4::
    LagSwitchEnabled := !LagSwitchEnabled
    Gosub, ToggleInternet
return

ToggleInternet:
    ; Указываем имя твоего адаптера (чаще всего "Ethernet" или "Wi-Fi")
    ; Если не работает, открой cmd -> ipconfig /all и посмотри точное имя
    adapterName := "Ethernet"

    if (LagSwitchEnabled) {
        ; Отключаем интернет
        RunWait, netsh interface set interface "%adapterName%" admin=disable,, hide
        if (ShowTooltips) {
            ToolTip, Lag Switch: ИНТЕРНЕТ ВЫКЛЮЧЕН (%adapterName%), 10, 90
            SetTimer, RemoveToolTip, 2000
        }
    } else {
        ; Включаем обратно
        RunWait, netsh interface set interface "%adapterName%" admin=enable,, hide
        if (ShowTooltips) {
            ToolTip, Lag Switch: ИНТЕРНЕТ ВКЛЮЧЕН (%adapterName%), 10, 90
            SetTimer, RemoveToolTip, 2000
        }
    }
return

; === Основные функции ===

; Автопробел
*Space::
    if (AutoSpaceEnabled) {
        While GetKeyState("Space", "P") {
            Send, {Space down}
            Sleep, 1
            Send, {Space up}
        }
    } else {
        Send, {Space}
    }
return

; Авто-E
SpamE:
    Send, e
return

; Удаление подсказок
RemoveToolTip:
    ToolTip
return