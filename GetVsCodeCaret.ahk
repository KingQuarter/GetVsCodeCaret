/**
 * ! Getting the caret coordinates via
 * ! https://github.com/zero-plusplus/vscode-operate-from-autohotkey/blob/340867b69ba8554d80490fc323f7fa69c268eaf9/demo/lib/ExecuteVsCodeCommand.ahk
 * ! doesn't work:
 */
#Include ExecuteVsCodeCommand.ahk

F1::
    caretCoords := ExecuteVsCodeCommand("operate-from-autohotkey.copy.context.caret.coordinates")
    ToolTip %caretCoords%
    return

/**
 * * Getting the coordinates via
 * * https://www.autohotkey.com/boards/viewtopic.php?p=447147#p447147
 * * does work:
 */
#Include Acc.ahk

F2::
	caret := GetCaret()
	caretCoords := caret.x ", " caret.y
	caretCoords := RegExReplace(caretCoords, "\.0+")
	ToolTip %caretCoords%
	return

GetDpi() {
	return DllCall("User32.dll\GetDpiForWindow", "Ptr", WinExist("A"))
}

GetCaret() {
	If (A_CaretX) {
		return { x: A_CaretX, y: A_CaretY }
	}
	Else {
		; should be long enough to ensure correct coords if caret has just moved
		Sleep, 20

		caret := Acc_ObjectFromWindow(WinExist("A"), OBJID_CARET := 0xFFFFFFF8)

		caretLocation := Acc_Location(caret)

		WinGetPos, winX, winY

		SysGet, monitorCount, MonitorCount

		multiplier := monitorCount > 1
			? 1 / (GetDpi() / 96)
			: 1

		x := (caretLocation.x - winX) * multiplier
		y := (caretLocation.y - winY) * multiplier

		return { x: x, y: y }
	}
}
