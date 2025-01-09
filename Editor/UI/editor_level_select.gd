extends Control

@onready var option_container : VBoxContainer = $Level_Options

var resource_path : String = "res://Levels/EditorTests/"
var scene_path : String = "res://Levels/EditorTests/"

var levels : Array[level_resource] = []

signal level_selected

func _ready() -> void:
	var dir = DirAccess.open(resource_path)
	dir.list_dir_begin()
	var currentLevel : String = dir.get_next()
	while currentLevel != "":

		if '.tres' in currentLevel:
			if '.remap' in currentLevel:
				currentLevel = currentLevel.trim_suffix('.remap')
			var holder = ResourceLoader.load(resource_path + currentLevel)
			
			levels.append(holder)

		currentLevel = dir.get_next()
	dir.list_dir_end()

	display_levels()

func display_levels() -> void:
	for n : level_resource in levels:
		var option : Button = Button.new()
		option.text = n.name
		option_container.add_child(option)
		option.pressed.connect(self.level_chosen)

func add_level() -> void:
	pass


func level_chosen() -> void:
	level_selected.emit()
	visible = false
