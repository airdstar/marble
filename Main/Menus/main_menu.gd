extends Node

var enable_play : bool = true
var enable_gallery : bool = false
#var enable_challenges : bool = false
#var enable_multiplayer : bool = false

@export var menu_container : VBoxContainer
@export var important_container : VBoxContainer
@export var logo : Sprite2D
@export var rotate_logo : Sprite2D

func _ready() -> void:
	place_control()

func place_control() -> void:
	menu_container.set_size(Vector2(get_window().get_size().x * 2 / 6, get_window().get_size().y / 6))
	menu_container.set_position(Vector2(get_window().get_size().x / 2 - (menu_container.size.x / 2), get_window().get_size().y / 2 + get_window().get_size().y / 10))
	
	important_container.set_size(Vector2(get_window().get_size().x / 15, get_window().get_size().y / 10))
	
	logo.set_scale(Vector2(float(get_window().get_size().x) / 4000, float(get_window().get_size().x) / 4000))
	logo.set_position(Vector2(get_window().get_size().x / 2, get_window().get_size().y / 4))

func _process(delta: float) -> void:
	rotate_logo.rotation = (rotate_logo.rotation + 0.5 * delta)

func play_pressed() -> void:
	Global.open_floor(Global.floor_type.PLAY, [])

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
