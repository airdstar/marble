extends Resource
class_name PlayerData

@export var highest_level : int = 0
@export var game_over_count : int = 0

@export var visited_levels : Array[int] = []

@export var player_color : Color = Color(1,1,1)

@export var current_version : String

func check_info() -> void:
	if highest_level == null:
		highest_level = 0
	
	if visited_levels == null:
		visited_levels = []
	
	if player_color == null:
		player_color = Color(1,1,1)
	
	if current_version != Global.current_version:
		current_version = Global.current_version
		visited_levels.clear()

func open_profile():
	var toReturn = preload("res://Main/Profile.tscn").instantiate()
	toReturn.set_data(self)
	return toReturn
