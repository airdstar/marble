extends Node

var resolutions : Dictionary = {
	"1920x1080" : Vector2(1920,1080),
	"1600x900" : Vector2(1600,900),
	"1366x768" : Vector2(1366,768),
	"1280x720" : Vector2(1280,720),
	"960x540" : Vector2(960,540),
	"854x480" : Vector2(854,480),
	}

var level_scene_path : String = "res://Levels/LevelScene/"
var level_resource_path : String = "res://Levels/LevelInfo/"

var pos_scenes : Dictionary = {
	"main_menu" : "res://Main/Menus/MainMenu.tscn",
	"settings" : "res://Main/Menus/SettingsMenu.tscn",
	"gallery" : "res://Main/Menus/Gallery.tscn",
	"editor" : "res://Editor/LevelEditor.tscn",
	"customization" : "res://Main/Menus/Customization.tscn"
	}

var pos_popup_scenes : Dictionary = {
	"settings" : "res://Main/Menus/SettingsMenu.tscn",
	"run_end" : "res://Levels/Handlers/RunEnd.tscn"
}

var cur_scene : String
var prev_scene : String
var current_scene : Node

var popup_scene : Node


func open_scene(scene : String) -> void:
	var holder = load(scene)
	holder = holder.instantiate()
	
	if current_scene != null:
		current_scene.queue_free()
	
	add_child(holder)
	current_scene = holder
	



func set_resolution() -> void:
	get_window().set_size(resolutions[PlayerInfo.player_settings.resolution])
	var screen_center = DisplayServer.screen_get_position() + DisplayServer.screen_get_size() / 2
	var window_size = get_window().get_size_with_decorations()
	get_window().set_position(screen_center - window_size / 2)

func set_fullscreen() -> void:
	if PlayerInfo.player_settings.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
