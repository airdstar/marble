extends Node

@export var menu_container : VBoxContainer
@export var important_container : HBoxContainer
@export var logo : Sprite2D
@export var rotate_logo : Sprite2D

func _ready() -> void:
	place_control()

func place_control() -> void:
	menu_container.set_size(Vector2(get_window().get_size().x / 3, get_window().get_size().y / 7))
	menu_container.set_position(Vector2(get_window().get_size().x / 2 - (menu_container.size.x / 2), get_window().get_size().y / 2 + get_window().get_size().y / 10))
	
	important_container.set_size(Vector2.ZERO)
	important_container.set_position(Vector2(get_window().get_size().x / 2 - (important_container.size.x / 2), get_window().get_size().y * 19 / 20 - important_container.size.y) )
	
	logo.set_scale(Vector2(float(get_window().get_size().x) / 4000, float(get_window().get_size().x) / 4000))
	logo.set_position(Vector2(get_window().get_size().x / 2, get_window().get_size().y / 4))

func _process(delta: float) -> void:
	rotate_logo.rotation = (rotate_logo.rotation + 0.5 * delta)

func play_pressed() -> void:
	Global.open_floor(FloorLevel.floor_type.PLAY, [])

func gallery_pressed() -> void:
	Global.open_scene("gallery")

func editor_pressed() -> void:
	Global.open_scene("editor")

func profile_pressed() -> void:
	Global.open_profile(PlayerInfo.player_data)

func settings_pressed() -> void:
	Global.open_popup("settings")

func customization_pressed() -> void:
	Global.open_scene("customization")

func exit_pressed() -> void:
	get_tree().quit()
