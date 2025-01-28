extends Node
class_name FloorLevel

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

var level_scene_path : String = "res://Levels/LevelScene/"
var level_resource_path : String = "res://Levels/LevelInfo/"
