extends Node
class_name main

enum possible_scenes {
	MAIN_MENU,
	SETTINGS,
	GALLERY,
	EDITOR,
	FLOOR_PLAY,
	FLOOR_GALLERY,
}

var cur_scene : possible_scenes
var prev_scene : possible_scenes
var child_scene

func _ready() -> void:
	Global.set_main(self)
