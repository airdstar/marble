extends Node

var save_path : String = "res://player_info.tres"

var player_data : PlayerData = PlayerData.new()

func _ready() -> void:
	load_info()

func load_info() -> void:
	if !FileAccess.file_exists(save_path):
		print("Save path is missing")
	else:
		player_data = load(save_path)

func save_info() -> void:
	ResourceSaver.save(player_data, save_path)

func clear_info() -> void:
	player_data = PlayerData.new()
	ResourceSaver.save(player_data, save_path)
