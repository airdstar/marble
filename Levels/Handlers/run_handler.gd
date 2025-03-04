extends Node
class_name RunHandler

var easy_levels : Array[level_resource]
var medium_levels : Array[level_resource]
var hard_levels : Array[level_resource]

var inRun := false

var current_difficulty : FloorLevel.difficulty
var current_level := 1
var levels_until_change := 5

var master : floor

signal difficulty_changed

func _ready() -> void:
	master = get_parent()
	if !master.set_pool:
		var dir = DirAccess.open(Global.level_resource_path)
		dir.list_dir_begin()
		var currentLevel : String = dir.get_next()
		while currentLevel != "":
			if '.remap' in currentLevel:
				currentLevel = currentLevel.trim_suffix('.remap')
			var holder = ResourceLoader.load(Global.level_resource_path + currentLevel)
			if holder.include_in_pool:
				match holder.level_difficulty:
					FloorLevel.difficulty.EASY:
						easy_levels.append(holder)
					FloorLevel.difficulty.MEDIUM:
						medium_levels.append(holder)
			
			currentLevel = dir.get_next()
		dir.list_dir_end()
	

func reset_run() -> void:
	levels_until_change = 5
	current_level = 1
	current_difficulty = FloorLevel.difficulty.EASY
	difficulty_changed.emit(easy_levels)

func next_level() -> void:
	current_level += 1
	if !master.set_pool:
		levels_until_change -= 1
		if levels_until_change == 0:
			change_difficulty()


func change_difficulty() -> void:
	match current_difficulty:
		FloorLevel.difficulty.EASY:
			current_difficulty = FloorLevel.difficulty.MEDIUM
			levels_until_change = 2
			difficulty_changed.emit(medium_levels)
		FloorLevel.difficulty.MEDIUM:
			current_difficulty = FloorLevel.difficulty.EASY
			levels_until_change = 5
			difficulty_changed.emit(easy_levels)
