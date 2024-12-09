extends Resource
class_name PlayerData

@export var highest_level : int = 0
@export var visited_levels : Array[int] = []

@export var player_color : Color = Color(1,1,1)
@export var player_settings : Settings = Settings.new()


func check_info() -> void:
	if highest_level == null:
		highest_level = 0
	
	if visited_levels == null:
		visited_levels = []
	
	if player_color == null:
		player_color = Color(1,1,1)
	
	if player_settings == null:
		player_settings = Settings.new()
	
	player_settings.check_info()
	
