extends Control

var shape_buttons : Array[Button] = []

@onready var option_holder : VBoxContainer = $VBoxContainer/ScrollContainer/VBoxContainer

signal shape_selected
signal part_selected

func _ready() -> void:
	pass
