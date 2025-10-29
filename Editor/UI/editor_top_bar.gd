extends Node

signal tool_selected

func pos_toggled(toggled_on: bool) -> void:
	if toggled_on:
		tool_selected.emit(editor.tool.POS)
		$Tools/HBoxContainer/Scale.set_pressed_no_signal(false)
		$Tools/HBoxContainer/Rotation.set_pressed_no_signal(false)
	else:
		tool_selected.emit(editor.tool.NONE)

func size_toggled(toggled_on: bool) -> void:
	if toggled_on:
		tool_selected.emit(editor.tool.SIZE)
		pos_button.button_pressed = false
		rot_button.button_pressed = false
	else:
		if !pos_button.button_pressed and !rot_button.button_pressed:
			tool_selected.emit(editor.tool.NONE)

func rot_toggled(toggled_on : bool) -> void:
	if toggled_on:
		tool_selected.emit(editor.tool.ROTATION)
		pos_button.button_pressed = false
		size_button.button_pressed = false
	else:
		if !pos_button.button_pressed and !size_button.button_pressed:
			tool_selected.emit(editor.tool.NONE)
