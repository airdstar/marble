extends Node

@export var background : Panel
@export var container : VBoxContainer
@export var stats : RichTextLabel
@export var restart : Button

func _ready():
	
	place_control()
	
	PlayerInfo.player_data.game_over_count += 1
	var level_reached : int = Global.current_scene.run_handler.current_level
	stats.text = "[center]"
	if level_reached > PlayerInfo.player_data.highest_level:
		stats.text += "New Record!\n"
		PlayerInfo.player_data.highest_level = level_reached
	stats.text += "You reached level %d!" % level_reached
	PlayerInfo.save_data()

func place_control() -> void:
	
	background.set_size(Vector2(get_window().get_size().x / 1.25, get_window().get_size().y / 1.25))
	background.set_position(Vector2(get_window().get_size().x / 2 - background.size.x / 2, get_window().get_size().y / 2 - background.size.y / 2))
	
	container.set_size(background.size / 1.1)
	container.set_position(Vector2(background.size.x / 2 - container.size.x / 2, background.size.y / 30))
	
	restart.set_custom_minimum_size(Vector2(background.size.x / 5, background.size.y / 10))
	stats.add_theme_font_size_override("normal_font_size", 30 * get_window().get_size().x / 1280)
	
	

func run_restart() -> void:
	Global.current_scene.start_game()
	Global.close_popup()
