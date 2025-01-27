extends Control

@export var name_field : LineEdit
@export var type_field : OptionButton
@export var difficulty_field : OptionButton
@export var include_box : CheckBox

func set_settings(level_info : level_resource) -> void:
	name_field.text = level_info.name
	type_field.selected = 0
	difficulty_field.selected = level_info.level_difficulty
	include_box.button_pressed = level_info.include_in_pool

func open_settings() -> void:
	visible = true

func close_settings() -> void:
	visible = false
