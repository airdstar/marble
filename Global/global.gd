extends Node

enum difficulty {
	EASY,
	MEDIUM,
	HARD
}

enum floor_type {
	PLAY,
	GALLERY,
	EDITOR,
	PACK,
	CHALLENGE
}

var main_scene : main
var runBase : Node3D

var level_scene_path : String = "res://Levels/EditorTests/Levels/"
var level_resource_path : String = "res://Levels/EditorTests/LevelInfo/"

var pos_scenes : Dictionary = {
	"main_menu" : "res://Main/Menus/MainMenu.tscn",
	"settings" : "res://Main/Menus/SettingsMenu.tscn",
	"gallery" : "res://Main/Menus/Gallery.tscn",
	"editor" : "res://Editor/LevelEditor.tscn",
	}


var resolutions_16_9 : Dictionary = {
	"1920x1080" : Vector2(1920,1080),
	"1600x900" : Vector2(1600,900),
	"1366x768" : Vector2(1366,768),
	"1280x720" : Vector2(1280,720),
	"960x540" : Vector2(960,540),
	"854x480" : Vector2(854,480),
	}

var resolutions_16_10 : Dictionary

var resolutions_4_3 : Dictionary

var aspect_ratios : Dictionary = {"16:9" : resolutions_16_9,
									"4:3" : resolutions_4_3,
									"16:10" : resolutions_16_10}

var easy_levels : Array[level_resource] = []
var medium_levels : Array[level_resource] = []
var hard_levels : Array[level_resource] = []

func _ready():
	PlayerInfo.load_info()
	
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

func set_main(main_in : main) -> void:
	main_scene = main_in
	open_scene("main_menu")

func open_scene(scene : String) -> void:
	main_scene.prev_scene = main_scene.cur_scene
	main_scene.cur_scene = scene
	
	if main_scene.child_scene != null:
		main_scene.child_scene.queue_free()
	
	var holder = load(pos_scenes[scene])
	holder = holder.instantiate()
	
	if holder != null:
		main_scene.child_scene = holder
		main_scene.add_child(holder)

func open_floor(type : floor_type, level_pool : Array[level_resource]):
	main_scene.prev_scene = main_scene.cur_scene
	main_scene.cur_scene = "floor"
	
	if main_scene.child_scene != null:
		main_scene.child_scene.queue_free()
	
	var holder = preload("res://Levels/Handlers/Floor.tscn").instantiate()
	
	main_scene.child_scene = holder
	main_scene.add_child(holder)

	holder.level_handler.set_level_pool(level_pool)

	match type:
		floor_type.PLAY:
			holder.is_run = true
			holder.allow_timer = true
		floor_type.GALLERY:
			holder.set_pool = true
			#holder.timer_count_up = true
		floor_type.EDITOR:
			holder.set_pool = true
		floor_type.PACK:
			holder.is_run = true
			holder.allow_timer = true
			holder.set_pool = true
		floor_type.CHALLENGE:
			holder.is_run = true
			#holder.timer_count_up = true
			holder.set_pool = true
			holder.in_order = true

	holder.call_deferred("start_game")

func set_resolution() -> void:
	get_window().set_size(aspect_ratios[PlayerInfo.player_settings.aspect_ratio][PlayerInfo.player_settings.resolution])
	
	var screen_center = DisplayServer.screen_get_position() + DisplayServer.screen_get_size() / 2
	var window_size = get_window().get_size_with_decorations()
	get_window().set_position(screen_center - window_size / 2)
	
	adjust_fonts()

func adjust_fonts() -> void:
	pass
