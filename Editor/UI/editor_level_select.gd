extends Control

@onready var level_container := $Select/ScrollContainer/Levels

var levels : Array[level_resource] = []
var unavailable_names : Array[String] = [""]

var selected_level : level_resource = null
var pressed_button : Button = null

signal level_selected

func _ready() -> void:
	show()
	show_select()
	for n : level_resource in Data.easy_levels + Data.med_levels + Data.hard_levels:
		add_level(n)

func add_level(level_info : level_resource) -> void:
	var button := Button.new()
	button.text = level_info.name
	unavailable_names.append(level_info.name)
	button.toggle_mode = true
	button.set_custom_minimum_size(Vector2(145, 50))
	level_container.add_child(button)
	button.toggled.connect(level_pressed.bind(level_info, button))

func level_pressed(toggled_on : bool, level_info : level_resource, button : Button) -> void:
	if toggled_on:
		selected_level = level_info
		if pressed_button != null:
			pressed_button.button_pressed = false
		pressed_button = button
	else:
		if selected_level == level_info:
			selected_level = null

func create_level() -> void:
	if $New/GridContainer/LevelName.text != "" and !unavailable_names.has($New/GridContainer/LevelName.text):
		var new = level_resource.new()
		new.name = $New/GridContainer/LevelName.text
		new.level_type = $New/GridContainer/LevelType.selected
		unavailable_names.append(new.name)
		
		var base = preload("res://Editor/LevelBase.tscn").instantiate()
		var to_save := PackedScene.new()
		to_save.pack(base)
		ResourceSaver.save(to_save, "res://Levels/LevelScene/" + new.name + ".tscn")
		
		new.associated_scene = ResourceLoader.load("res://Levels/LevelScene/" + new.name + ".tscn")
		ResourceSaver.save(new, "res://Levels/LevelInfo/" + new.name + ".tres")
		
		add_level(new)
		show_select()

func new_pressed() -> void:
	$Select.hide()
	$New.show()
	$New/GridContainer/LevelName.text = ""
	$New/GridContainer/LevelType.selected = 0
	if pressed_button:
		pressed_button.button_pressed = false

func edit_pressed() -> void:
	if selected_level:
		level_selected.emit(selected_level)
		hide()

func delete_pressed() -> void:
	if selected_level:
		unavailable_names.erase(selected_level.text)
		pressed_button.queue_free()
		Data.easy_levels.erase(selected_level)
		Data.med_levels.erase(selected_level)
		Data.hard_levels.erase(selected_level)
		DirAccess.remove_absolute("res://Levels/LevelInfo/" + selected_level.name + ".tres")
		if FileAccess.file_exists("res://Levels/LevelScene/" + selected_level.name + ".tscn"):
			DirAccess.remove_absolute("res://Levels/LevelScene/" + selected_level.name + ".tscn")
		selected_level = null

func show_select() -> void:
	show()
	$New.hide()
	$Select.show()
