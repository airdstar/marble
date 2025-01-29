extends Node

var resolutions_16_9 : Dictionary = {
	"1920x1080" : Vector2(1920,1080),
	"1600x900" : Vector2(1600,900),
	"1366x768" : Vector2(1366,768),
	"1280x720" : Vector2(1280,720),
	"960x540" : Vector2(960,540),
	"854x480" : Vector2(854,480),
	}

var resolutions_16_10 : Dictionary = {
	"1920x1200" : Vector2(1920,1200)
	}

var resolutions_4_3 : Dictionary = {
	"1200x900" : Vector2(1200,900)
	}

var aspect_ratios : Dictionary = {"16:9" : resolutions_16_9,
									"4:3" : resolutions_4_3,
									"16:10" : resolutions_16_10}

var level_scene_path : String = "res://Levels/LevelScene/"
var level_resource_path : String = "res://Levels/LevelInfo/"

var pos_scenes : Dictionary = {
	"main_menu" : "res://Main/Menus/MainMenu.tscn",
	"settings" : "res://Main/Menus/SettingsMenu.tscn",
	"gallery" : "res://Main/Menus/Gallery.tscn",
	"editor" : "res://Editor/LevelEditor.tscn",
	}

var pos_popup_scenes : Dictionary = {
	"settings" : "res://Main/Menus/SettingsMenu.tscn",
	"run_end" : 2
}

var main_scene : main
var current_scene : Node

func _ready():
	PlayerInfo.load_info()

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
		current_scene = holder
		main_scene.child_scene = holder
		main_scene.add_child(holder)

func open_floor(type : FloorLevel.floor_type, level_pool : Array[level_resource]):
	main_scene.prev_scene = main_scene.cur_scene
	main_scene.cur_scene = "floor"
	
	if main_scene.child_scene != null:
		main_scene.child_scene.queue_free()
	
	var holder = preload("res://Levels/Handlers/Floor.tscn").instantiate()
	current_scene = holder
	main_scene.child_scene = holder
	main_scene.add_child(holder)

	holder.level_handler.set_level_pool(level_pool)

	match type:
		FloorLevel.floor_type.PLAY:
			holder.is_run = true
			holder.allow_timer = true
		FloorLevel.floor_type.GALLERY:
			holder.set_pool = true
			#holder.timer_count_up = true
		FloorLevel.floor_type.EDITOR:
			holder.set_pool = true
		FloorLevel.floor_type.PACK:
			holder.is_run = true
			holder.allow_timer = true
			holder.set_pool = true
		FloorLevel.floor_type.CHALLENGE:
			holder.is_run = true
			#holder.timer_count_up = true
			holder.set_pool = true
			holder.in_order = true
	
	current_scene.call_deferred("start_game")


func open_popup(scene : String) -> void:
	if main_scene.popup_scene != null:
		main_scene.popup_scene.queue_free()
	
	var holder = load(pos_popup_scenes[scene])
	holder = holder.instantiate()

	if holder != null:
		main_scene.popup_scene = holder
		main_scene.add_child(holder)

func close_popup() -> void:
	if main_scene.popup_scene != null:
		main_scene.popup_scene.queue_free()
	
	main_scene.popup_scene = null

func open_profile(player_info : PlayerData) -> void:
	if main_scene.popup_scene != null:
		main_scene.popup_scene.queue_free()
	var holder = preload("res://Main/Menus/Profile.tscn").instantiate()
	holder.set_data(player_info)
	main_scene.popup_scene = holder
	main_scene.add_child(holder)
	

func set_resolution() -> void:
	get_window().set_size(aspect_ratios[PlayerInfo.player_settings.aspect_ratio][PlayerInfo.player_settings.resolution])
	
	var screen_center = DisplayServer.screen_get_position() + DisplayServer.screen_get_size() / 2
	var window_size = get_window().get_size_with_decorations()
	get_window().set_position(screen_center - window_size / 2)
	
	if PlayerInfo.player_settings.fullscreen:
		pass

	adjust_fonts()

func adjust_fonts() -> void:
	pass
