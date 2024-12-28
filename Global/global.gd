extends Node

var main : Node
var runBase : Node3D

var current_version : String = "0.0.2.0"

var resolutions_16_9 : Dictionary = {"1920x1080" : Vector2(1920,1080),
									"1600x900" : Vector2(1600,900),
									"1366x768" : Vector2(1366,768),
									"1280x720" : Vector2(1280,720),
									"960x540" : Vector2(960,540),
									"854x480" : Vector2(854,480),}

var resolutions_16_10 : Dictionary

var resolutions_4_3 : Dictionary

var aspect_ratios : Dictionary = {"16:9" : resolutions_16_9,
									"4:3" : resolutions_4_3,
									"16:10" : resolutions_16_10}

var easy_levels : Array[level_resource] = []
var medium_levels : Array[level_resource] = []
var hard_levels : Array[level_resource] = []
var test_levels : Array[level_resource] = []

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
		
		if holder.needs_testing:
			test_levels.append(holder)
		
		currentLevel = dir.get_next()
	dir.list_dir_end()

func set_resolution(res : Vector2) -> void:
	get_window().set_size(res)
	
	var screen_center = DisplayServer.screen_get_position() + DisplayServer.screen_get_size() / 2
	var window_size = get_window().get_size_with_decorations()
	get_window().set_position(screen_center - window_size / 2)
