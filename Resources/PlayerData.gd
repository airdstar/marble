extends Resource
class_name PlayerData

@export var highest_level : int = 0
@export var game_over_count : int = 0

@export var player_color : Color = Color(1,1,1)


func check_info() -> void:
	if highest_level == null:
		highest_level = 0
	
	if player_color == null:
		player_color = Color(1,1,1)

func open_profile():
	var toReturn = preload("res://Main/Menus/Profile.tscn").instantiate()
	toReturn.set_data(self)
	return toReturn
