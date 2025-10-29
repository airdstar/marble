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
		$Tools/HBoxContainer/Position.set_pressed_no_signal(false)
		$Tools/HBoxContainer/Rotation.set_pressed_no_signal(false)
	else:
		tool_selected.emit(editor.tool.NONE)

func rot_toggled(toggled_on : bool) -> void:
	if toggled_on:
		tool_selected.emit(editor.tool.ROTATION)
		$Tools/HBoxContainer/Position.set_pressed_no_signal(false)
		$Tools/HBoxContainer/Scale.set_pressed_no_signal(false)
	else:
		tool_selected.emit(editor.tool.NONE)
