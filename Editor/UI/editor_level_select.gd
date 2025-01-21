extends Control

@onready var option_container := $LevelSelect/ScrollContainer/VBoxContainer

@onready var level_select := $LevelSelect
@onready var new_level := $NewLevel

var resource_path : String = "res://Levels/EditorTests/LevelInfo/"

var levels : Array[level_resource] = []

var selected_level : level_resource = null

signal level_selected

func _ready() -> void:
	var dir = DirAccess.open(resource_path)
	dir.list_dir_begin()
	var currentLevel : String = dir.get_next()
	while currentLevel != "":
		if '.remap' in currentLevel:
			currentLevel = currentLevel.trim_suffix('.remap')
		var holder = ResourceLoader.load(resource_path + currentLevel)
		
		levels.append(holder)
		
		
		new_level.unavailable_names.append(holder.name)
		
		currentLevel = dir.get_next()
	dir.list_dir_end()
	display_levels()


func display_levels() -> void:
	for n : level_resource in levels:
		add_level(n)

func add_level(level_info : level_resource) -> void:
	var option : Button = Button.new()
	option.text = level_info.name
	option.toggle_mode = true
	option_container.add_child(option)
	option.toggled.connect(level_pressed.bind(level_info, option))

func delete_level():
	for n : Button in option_container.get_children():
		if n.button_pressed:
			new_level.unavailable_names.remove_at(new_level.unavailable_names.find(n.text))
			n.queue_free()
			break

func level_pressed(toggled_on : bool, level_info : level_resource, option_button : Button) -> void:
	if toggled_on:
		selected_level = level_info
		
		for n in option_container.get_children():
			if n == option_button:
				continue
			n.button_pressed = false
	else:
		if selected_level == level_info:
			selected_level = null

func level_created(level_info : level_resource) -> void:
	var level_base = preload("res://Editor/LevelBase.tscn").instantiate()
	var to_save := PackedScene.new()
	to_save.pack(level_base)
	var saving = ResourceSaver.save(to_save, Global.level_scene_path + level_info.name + ".tscn")
	if saving != OK:
		print("Error creating level")
	else:
		level_info.associated_scene = ResourceLoader.load(Global.level_scene_path + level_info.name + ".tscn")
		saving = ResourceSaver.save(level_info, Global.level_resource_path + level_info.name + ".tres")
		if saving != OK:
			print("Error creating level")
		else:
			add_level(level_info)
			level_select_show()

func new_level_pressed() -> void:
	level_select.visible = false
	new_level.visible = true

func level_select_show() -> void:
	level_select.visible = true
	new_level.visible = false
	new_level.reset_fields()

func edit_pressed() -> void:
	if selected_level != null:
		level_selected.emit(selected_level)
		visible = false

func delete_pressed() -> void:
	if selected_level != null:
		delete_level()
		levels.remove_at(levels.find(selected_level))
		DirAccess.remove_absolute(Global.level_resource_path + selected_level.name + ".tres")
		if FileAccess.file_exists(Global.level_scene_path + selected_level.name + ".tscn"):
			DirAccess.remove_absolute(Global.level_scene_path + selected_level.name + ".tscn")
		selected_level = null
