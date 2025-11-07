extends CanvasLayer

func open_level_select() -> void:
	$LevelSelect.show()
	$TopBar.hide()
	$Parts.hide()
	$Sections.hide()
	$Properties.hide()

func level_selected() -> void:
	$TopBar.show()
	$Parts.show()
	$Sections.show()
	$Properties.show()
