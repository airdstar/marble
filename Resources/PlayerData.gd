extends Resource
class_name PlayerData

@export var highest_level : int = 0
@export var game_over_count : int = 0

@export var player_customization : PlayerCustomization = PlayerCustomization.new()

func check_info() -> void:
	if highest_level == null:
		highest_level = 0
	
	if player_customization == null:
		player_customization = PlayerCustomization.new()
