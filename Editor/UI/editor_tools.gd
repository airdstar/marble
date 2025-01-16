extends Node

@onready var pos_button := $VBoxContainer/HBoxContainer/Position
@onready var size_button := $VBoxContainer/HBoxContainer/Size

signal tool_selected

func _ready() -> void:
	pass

func pos_toggled(toggled_on: bool) -> void:
	if toggled_on:
		tool_selected.emit(editor.tool.POS)
		size_button.button_pressed = false
	else:
		if !size_button.button_pressed:
			tool_selected.emit(editor.tool.NONE)

func size_toggled(toggled_on: bool) -> void:
	if toggled_on:
		tool_selected.emit(editor.tool.SIZE)
		pos_button.button_pressed = false
	else:
		if !pos_button.button_pressed:
			tool_selected.emit(editor.tool.NONE)
