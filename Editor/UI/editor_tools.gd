extends Node

@onready var pos_button := $VBoxContainer/HBoxContainer/Position
@onready var size_button := $VBoxContainer/HBoxContainer/Size

signal position_selected
signal size_selected
signal holder_selected

func _ready() -> void:
	pass

func pos_toggled(toggled_on: bool) -> void:
	if toggled_on:
		position_selected.emit()
		size_button.button_pressed = false

func size_toggled(toggled_on: bool) -> void:
	if toggled_on:
		size_selected.emit()
		pos_button.button_pressed = false
