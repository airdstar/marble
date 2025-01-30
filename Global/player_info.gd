extends Node

var data_save_path : String = "user://player_data.tres"
var settings_save_path : String = "user://player_settings.tres"

var player_data : PlayerData = PlayerData.new()
var player_settings : Settings = Settings.new()

func load_info() -> void:
	if !FileAccess.file_exists(data_save_path):
		print("Data path is missing")
		clear_data()
	else:
		player_data = ResourceLoader.load(data_save_path)
		if player_data != null:
			player_data.check_info()
		else:
			clear_data()
	
	if !FileAccess.file_exists(settings_save_path):
		print("Settings path is missing")
		clear_settings()
	else:
		player_settings = ResourceLoader.load(settings_save_path)
		player_settings.check_info()
		Global.set_resolution()

func save_data() -> void:
	ResourceSaver.save(player_data, data_save_path)

func save_settings() -> void:
	ResourceSaver.save(player_settings, settings_save_path)

func clear_data() -> void:
	player_data = PlayerData.new()
	ResourceSaver.save(player_data, data_save_path)

func clear_settings() -> void:
	player_settings = Settings.new()
	ResourceSaver.save(player_settings, settings_save_path)
	Global.set_resolution()
