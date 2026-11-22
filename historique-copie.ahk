#Requires AutoHotkey v2.0
#SingleInstance Force

MAX_HISTORY := 7        ; nombre d'éléments mémorisés
COOLDOWN    := 1200   ; ms max entre deux Ctrl+V pour "voyager dans lhistoriq"

history    := []      ; history[1] = copie la plus récente
idx        := 0
lastTime   := 0
ignoreNext := ""      ; texte que le script met lui-même dans le presse-papier
cycled     := false   ; true si le presse-papier contient un élément choisi en voyageant

OnClipboardChange(OnClip)

OnClip(type) {
    global history, ignoreNext, cycled, MAX_HISTORY
    if (type != 1) {               ; on ne garde que le texte
        cycled := false
        return
    }
    txt := A_Clipboard
    if (txt == ignoreNext) {       ; c'est nous qui l'avons mis, on ignore
        ignoreNext := ""
        return
    }
    cycled := false                ; vraie nouvelle copie
    for i, v in history            ; pas de doublons
        if (v == txt) {
            history.RemoveAt(i)
            break
        }
    history.InsertAt(1, txt)
    if (history.Length > MAX_HISTORY)
        history.Pop()
}

$^v:: {
    global idx, lastTime, ignoreNext, cycled
    chaining := (A_TickCount - lastTime < COOLDOWN) && history.Length > 1

    if !chaining {                 ; collage normal
        idx := 1
        if (cycled && history.Length) { ; remet la dernière vraie copie
            ignoreNext := history[1]
            A_Clipboard := history[1]
            ClipWait 1
            Sleep 100                  ; laisse le temps au presse-papier d'être prêt
            cycled := false
        }
        Send "^v"
        lastTime := A_TickCount
        return
    }

    Send "^z"                      ; annule le collage précédent
    idx := Mod(idx, history.Length) + 1   ; élément suivant (revient au début après le dernier)
    txt := history[idx]
    ignoreNext := txt
    A_Clipboard := txt
    ClipWait 1
    Sleep 100                      ; laisse le temps au presse-papier d'être prêt
    cycled := true
    Send "^v"
    lastTime := A_TickCount
}