extends PanelContainer

func part_selected() -> void:
	pass

func part_unselected() -> void:
	pass

func shape_selected() -> void:
	$PanelContainer/Tabs/ShapeTab.disabled = false
	$PanelContainer/Tabs/ShapeTab.button_pressed = true

func shape_unselected() -> void:
	$PanelContainer/Tabs/ShapeTab.disabled = true


func tab_pressed(toggled_on : bool, tab : int) -> void:
	if toggled_on:
		if tab == 0:
			%Info.set_adjusting(%Info.adjustable.PART)
			
		else:
			%Info.set_adjusting(%Info.adjustable.SHAPE)
	else:
		%Info.set_adjusting(%Info.adjustable.NONE)

func show_part_info() -> void:
	pass

func show_shape_info() -> void:
	pass
