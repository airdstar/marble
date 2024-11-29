extends Node

var save_path : String = "res://player_info.save"

var highest_level : int = 0
var highest_points : int = 0

var player_color : Color = Color(1,1,1)

func _ready() -> void:
	load_info()

func load_info() -> void:
	if !FileAccess.file_exists(save_path):
		print("Save path is missing")
		return

	var file = FileAccess.open(save_path, FileAccess.READ)

	highest_level = file.get_var(highest_level)
	player_color = file.get_var(player_color)

func save_info() -> void:

	var file = FileAccess.open(save_path, FileAccess.WRITE)

	file.store_var(highest_level)
	file.store_var(player_color)

func clear_info() -> void:
	
	var file = FileAccess.open(save_path, FileAccess.WRITE)

	highest_level = 0
	highest_points = 0
	player_color = Color(1,1,1)

	file.store_var(highest_level)
	file.store_var(player_color)