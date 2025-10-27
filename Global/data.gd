extends Node

var data = PlayerData.new()
var settings = Settings.new()

var resolutions : Dictionary = {
	"1920x1080" : Vector2(1920,1080), "1600x900" : Vector2(1600,900),
	"1366x768" : Vector2(1366,768), "1280x720" : Vector2(1280,720),
	"960x540" : Vector2(960,540), "854x480" : Vector2(854,480),
}

var colors : Array[Color] = [
	Color(0.9, 0.2, 0.339, 1.0), Color(0.0, 0.769, 0.4, 1.0),
	Color(0.1, 0.49, 0.9, 1.0), Color(0.9, 0.827, 0.0, 1.0),
	Color(0.6, 0.232, 0.704, 1.0), Color(0.9, 0.3, 0.307, 1.0),
	Color(0.98, 0.0, 0.926, 1.0), Color(0.26, 0.809, 0.646, 1.0),
	Color(0.592, 0.501, 0.307, 1.0), Color(0.688, 0.642, 0.692, 1.0)
]
var decals : Array[Texture2D]

var easy_levels : Array[level_resource]
var med_levels : Array[level_resource]
var hard_levels : Array[level_resource]


func _ready() -> void:
	load_data()
	load_settings()
	
	load_decals()
	load_levels()

func load_data() -> void:
	if FileAccess.file_exists("user://data.tres"):
		data = ResourceLoader.load("user://data.tres")

func load_settings() -> void:
	if FileAccess.file_exists("user://settings.tres"):
		settings = ResourceLoader.load("user://settings.tres")
	Game.set_resolution()
	Game.set_fullscreen()

func save_data() -> void:
	ResourceSaver.save(data, "user://data.tres")

func save_settings() -> void:
	ResourceSaver.save(settings, "user://settings.tres")

func clear_data() -> void:
	data = PlayerData.new()
	save_data()

func clear_settings() -> void:
	settings = Settings.new()
	Game.set_fullscreen()
	save_settings()

func load_decals() -> void:
	var dir = DirAccess.open("res://Assets/Customization/")
	dir.list_dir_begin()
	var current : String = dir.get_next()
	while current != "":
		if '.remap' in current:
			current = current.trim_suffix('.remap')
		
		if '.import' in current:
			current = dir.get_next()
			continue
		
		var holder = ResourceLoader.load("res://Assets/Customization/" + current)
		decals.append(holder)
		current = dir.get_next()
	dir.list_dir_end()

func load_levels() -> void:
	var dir = DirAccess.open("res://Levels/LevelInfo/")
	dir.list_dir_begin()
	var currentLevel : String = dir.get_next()
	while currentLevel != "":
		if '.remap' in currentLevel:
			currentLevel = currentLevel.trim_suffix('.remap')
		var holder = ResourceLoader.load("res://Levels/LevelInfo/" + currentLevel)
		match holder.level_difficulty:
			FloorLevel.difficulty.EASY:
				easy_levels.append(holder)
			FloorLevel.difficulty.MEDIUM:
				med_levels.append(holder)
			FloorLevel.difficulty.HARD:
				hard_levels.append(holder)
		currentLevel = dir.get_next()
	dir.list_dir_end()

func get_in_pool_levels(difficulty : FloorLevel.difficulty) -> Array[level_resource]:
	var to_return : Array[level_resource]
	var array : Array[level_resource]
	match difficulty:
		FloorLevel.difficulty.EASY:
			array = easy_levels
		FloorLevel.difficulty.MEDIUM:
			array = med_levels
		FloorLevel.difficulty.HARD:
			array = hard_levels
	for n in array:
		if n.include_in_pool:
			to_return.append(n)
	return to_return
