extends CanvasLayer

func open_level_select() -> void:
	$LevelSelect.show()
	$TopBar.hide()
	$Parts.hide()
	$Sections.hide()
