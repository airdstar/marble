extends Node
class_name Paths

var level_scene_path : String = "res://Levels/LevelScene/"
var level_resource_path : String = "res://Levels/LevelInfo/"

var pos_scenes : Dictionary = {
	"main_menu" : "res://Main/Menus/MainMenu.tscn",
	"settings" : "res://Main/Menus/SettingsMenu.tscn",
	"gallery" : "res://Main/Menus/Gallery.tscn",
	"editor" : "res://Editor/LevelEditor.tscn",
	}

var pos_popup_scenes : Dictionary = {
	"settings" : "res://Main/Menus/SettingsMenu.tscn"
	"run_end" : 2
}


