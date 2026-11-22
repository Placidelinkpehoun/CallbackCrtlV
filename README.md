# CallbackCtrlV

**Press Ctrl+V again to paste the previous copy.** A tiny AutoHotkey v2 script that turns Ctrl+V into a clipboard history: no popup, no extra shortcut.

![Demo: copying Apple, Banana, Cherry, then pressing Ctrl+V repeatedly to cycle through them](demo/ctrlv-notepad.gif)

## How it works

1. **Copy things as usual.** The script remembers your last 7 text copies.
2. **Ctrl+V** pastes normally (your latest copy).
3. **Press Ctrl+V again within 1.2 s**: the text you just pasted is replaced by the previous copy.
   Keep pressing to go further back. After the oldest one, it loops back to the newest.
4. **Wait more than 1.2 s** and Ctrl+V is a normal paste again, of your latest copy.

Under the hood, each extra Ctrl+V sends Ctrl+Z (undo the last paste), puts the next history item in the clipboard and pastes it.

## Installation

**Option 1: standalone .exe (no install needed)**

Download `historique-copie.exe` from the [Releases](../../releases) page and run it.
A green **H** icon appears in the system tray; right-click it → *Exit* to stop.


**Option 2: run the script**

1. Install [AutoHotkey v2](https://www.autohotkey.com/).
2. Download `historique-copie.ahk` and double-click it.

**Start with Windows**

Press `Win+R`, type `shell:startup`, press Enter, and put a shortcut to the `.exe` or `.ahk` in that folder.

> Run only one of them at a time (the .exe **or** the .ahk), otherwise both will catch Ctrl+V.

## Settings

Two variables at the top of `historique-copie.ahk`:

| Variable      | Default | Meaning                                                      |
|---------------|---------|--------------------------------------------------------------|
| `MAX_HISTORY` | `7`     | Number of copies remembered                                  |
| `COOLDOWN`    | `1200`  | Max delay (ms) between two Ctrl+V to keep cycling the history |

Edit them and re-run the script. With the .exe you can't change them: use the .ahk.

## Good to know

- **Text only.** Images and files copied are ignored and don't enter the history.
- **No duplicates.** Copying something already in the history moves it back to the top.
- **Relies on Ctrl+Z.** In apps where undo doesn't cleanly remove a paste (some terminals, games, certain web fields), cycling may misbehave. A single Ctrl+V always works normally.
- **Memory only.** The history is never written to disk and is cleared when the script exits.

## License

MIT
