extends Node

func pos_toggled(toggled_on: bool) -> void:
	if toggled_on:
		%Adjust.set_tool(%Adjust.tool.POS)
		$Tools/HBoxContainer/Scale.set_pressed_no_signal(false)
		$Tools/HBoxContainer/Rotation.set_pressed_no_signal(false)
	else:
		%Adjust.set_tool(%Adjust.tool.NONE)

func size_toggled(toggled_on: bool) -> void:
	if toggled_on:
		%Adjust.set_tool(%Adjust.tool.SCALE)
		$Tools/HBoxContainer/Position.set_pressed_no_signal(false)
		$Tools/HBoxContainer/Rotation.set_pressed_no_signal(false)
	else:
		%Adjust.set_tool(%Adjust.tool.NONE)

func rot_toggled(toggled_on : bool) -> void:
	if toggled_on:
		%Adjust.set_tool(%Adjust.tool.ROT)
		$Tools/HBoxContainer/Position.set_pressed_no_signal(false)
		$Tools/HBoxContainer/Scale.set_pressed_no_signal(false)
	else:
		%Adjust.set_tool(%Adjust.tool.NONE)
