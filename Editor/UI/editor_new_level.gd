extends Node

@onready var name_field := $VBoxContainer/LineEdit
@onready var type_field := $VBoxContainer/OptionButton
var unavailable_names : Array[String] = [""]

signal level_created

func _ready() -> void:
	pass

func reset_fields() -> void:
	name_field.text = ""
	type_field.selected = 0

func create_pressed() -> void:
	if !unavailable_names.has(name_field.text):
		var level_holder : level_resource = level_resource.new()
		unavailable_names.append(name_field.text)
		level_holder.name = name_field.text
		level_holder.level_type = type_field.selected
		level_created.emit(level_holder)
