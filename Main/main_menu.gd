extends Node

var enable_play : bool = true
var enable_gallery : bool = false
#var enable_challenges : bool = false
#var enable_multiplayer : bool = false

@onready var play_container : VBoxContainer = $PlayContainer
@onready var settings_button : Button = $Settings

func _ready() -> void:
	place_control()

func place_control() -> void:
	play_container.call_deferred("set_size", Vector2(get_window().get_size().x / 7, get_window().get_size().y * 5 / 6))
	play_container.call_deferred("set_position", Vector2(get_window().get_size().x / 2 - get_window().get_size().x / 14, 0))
	
	settings_button.set_size(Vector2(get_window().get_size().y / 12, get_window().get_size().y / 12))
	settings_button.set_position(Vector2.ZERO)
	

func play_pressed() -> void:
	Global.open_scene("floor_play")

func gallery_pressed() -> void:
	Global.open_scene("gallery")

func editor_pressed() -> void:
	Global.open_scene("editor")

func profile_pressed() -> void:
	add_child(PlayerInfo.player_data.open_profile())

func settings_pressed() -> void:
	Global.open_scene("settings")

func exit_pressed() -> void:
	get_tree().quit()
