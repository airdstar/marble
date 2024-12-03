extends Node

var main : Node
var runBase : Node3D

var easy_levels : Array[level_resource] = []
var medium_levels : Array[level_resource] = []
var hard_levels : Array[level_resource] = []

func _ready():
	var dir = DirAccess.open("res://Levels/Info/")
	dir.list_dir_begin()
	var currentLevel : String = dir.get_next()
	while currentLevel != "":
		if '.tres.remap' in currentLevel:
			currentLevel = currentLevel.trim_suffix('.remap')
		var holder = ResourceLoader.load("res://Levels/Info/" + currentLevel)
		
		if currentLevel.begins_with(str(1)):
			easy_levels.append(holder)
		elif currentLevel.begins_with(str(2)):
			medium_levels.append(holder)
		elif currentLevel.begins_with(str(3)):
			hard_levels.append(holder)
			
		currentLevel = dir.get_next()
	dir.list_dir_end()
