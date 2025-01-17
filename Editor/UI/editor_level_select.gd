extends Control

@onready var option_container := $LevelSelect/ScrollContainer/VBoxContainer

@onready var level_select := $LevelSelect
@onready var new_level := $NewLevel

var resource_path : String = "res://Levels/EditorTests/LevelInfo/"
var scene_path : String = "res://Levels/EditorTests/"

var levels : Array[level_resource] = []

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
	option_container.add_child(option)
	option.pressed.connect(level_chosen.bind(level_info))

func level_chosen(level_info : level_resource) -> void:
	if level_info.associated_scene == null:
		var holder = preload("res://Editor/LevelBase.tscn")
		level_info.associated_scene = holder
	level_selected.emit(level_info)
	visible = false

func level_created(level_info : level_resource) -> void:
	var saving = ResourceSaver.save(level_info, resource_path + level_info.name + ".tres")
	if saving != OK:
		print("Error")
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



	
