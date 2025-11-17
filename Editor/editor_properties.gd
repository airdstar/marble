extends Control

func clear() -> void:
	$Tabs/Tabs/PartTab.hide()
	$Tabs/Tabs/ShapeTab.hide()
	$Properties.hide()
	$Tabs.hide()

func part_selected() -> void:
	$Tabs.show()
	$Tabs/Tabs/PartTab.show()
	%Info.set_adjusting(%Info.adjustable.PART)
	tab_pressed(true, 0)

func part_unselected() -> void:
	if $Tabs/Tabs/PartTab.button_pressed:
		$Tabs/Tabs/PartTab.button_pressed = false
	$Tabs/Tabs/PartTab.hide()

func shape_selected() -> void:
	$Tabs.show()
	$Tabs/Tabs/ShapeTab.show()
	tab_pressed(true, 1)

func shape_unselected() -> void:
	$Tabs/Tabs/ShapeTab.hide()


func tab_pressed(toggled_on : bool, tab : int) -> void:
	if toggled_on:
		$Properties.show()
		if tab == 0:
			$Tabs/Tabs/PartTab.set_pressed_no_signal(true)
			%Info.set_adjusting(%Info.adjustable.PART)
			update_info()
			$Tabs/Tabs/ShapeTab.set_pressed_no_signal(false)
		else:
			$Tabs/Tabs/ShapeTab.set_pressed_no_signal(true)
			%Info.set_adjusting(%Info.adjustable.SHAPE)
			update_info()
			$Tabs/Tabs/PartTab.set_pressed_no_signal(false)
	else:
		$Properties.hide()
		%Info.set_adjusting(%Info.adjustable.NONE)

func update_info() -> void:
	update_pos_info()
	update_scale_info()
	update_rotation_info()
	if %Info.adjusting == %Info.adjustable.SHAPE:
		pass

func update_pos_info() -> void:
	$Properties/ScrollContainer/VBoxContainer/GridContainer/Position.text = "Position | "
	var text : String = ""
	if %Info.adjusting == %Info.adjustable.PART:
		text = "%.1f, %.1f, %.1f" % [%Info.selected_part.position.x,%Info.selected_part.position.y,%Info.selected_part.position.z]
	elif %Info.adjusting == %Info.adjustable.SHAPE:
		text = "%.1f, %.1f, %.1f" % [%Info.selected_shape.total_offset.x, %Info.selected_shape.total_offset.y, %Info.selected_shape.total_offset.z]
	$Properties/ScrollContainer/VBoxContainer/GridContainer/Position.text += text

func update_scale_info() -> void:
	$Properties/ScrollContainer/VBoxContainer/GridContainer/Scale.text = "Scale | "
	var text : String = ""
	if %Info.adjusting == %Info.adjustable.PART:
		text = "%.1f, %.1f, %.1f" % [%Info.selected_part.scale.x,%Info.selected_part.scale.y,%Info.selected_part.scale.z]
	elif %Info.adjusting == %Info.adjustable.SHAPE:
		text = "%.1f, %.1f, %.1f" % [%Info.selected_shape.size.x, %Info.selected_shape.size.y, %Info.selected_shape.size.z]
	$Properties/ScrollContainer/VBoxContainer/GridContainer/Scale.text += text
	
func update_rotation_info() -> void:
	$Properties/ScrollContainer/VBoxContainer/GridContainer/Rotation.text = "Rotation | "
	var text : String = ""
	if %Info.adjusting == %Info.adjustable.PART:
		text = "%.1f, %.1f, %.1f" % [%Info.selected_part.rotation.x,%Info.selected_part.rotation.y,%Info.selected_part.rotation.z]
	elif %Info.adjusting == %Info.adjustable.SHAPE:
		var axis = %Info.selected_shape.rotation.get_axis()
		text = "%.1f, %.1f, %.1f" % [axis.x, axis.y, axis.z]
	$Properties/ScrollContainer/VBoxContainer/GridContainer/Rotation.text += text
