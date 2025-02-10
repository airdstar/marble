extends Node

@export var menu_container : VBoxContainer
@export var important_container : HBoxContainer
@export var logo : Sprite2D
@export var rotate_logo : Sprite2D

@export var background : SubViewport

var dummies : Array[player]

func _ready() -> void:
	place_control()
	set_background()

func place_control() -> void:
	menu_container.set_size(Vector2(get_window().get_size().x / 3, get_window().get_size().y / 7))
	menu_container.set_position(Vector2(get_window().get_size().x / 2 - (menu_container.size.x / 2), get_window().get_size().y / 2 + get_window().get_size().y / 10))
	
	important_container.set_size(Vector2.ZERO)
	important_container.set_position(Vector2(get_window().get_size().x / 2 - (important_container.size.x / 2), get_window().get_size().y * 19 / 20 - important_container.size.y) )
	
	logo.set_scale(Vector2(float(get_window().get_size().x) / 4000, float(get_window().get_size().x) / 4000))
	logo.set_position(Vector2(get_window().get_size().x / 2, get_window().get_size().y / 4))
	
	background.set_size(get_window().get_size())

func _process(delta: float) -> void:
	rotate_logo.rotation = (rotate_logo.rotation + 0.3 * delta)

func open_floor() -> void:
	Global.open_floor(FloorLevel.floor_type.PLAY, [])

func open_scene(scene_name : String) -> void:
	Global.open_scene(scene_name)

func open_popup(popup_name : String) -> void:
	Global.open_popup(popup_name)

func open_profile() -> void:
	Global.open_profile(PlayerInfo.player_data)

func exit() -> void:
	get_tree().quit()

func set_background() -> void:
	while(true):
		await get_tree().create_timer(randf_range(0.2, 0.8)).timeout
		var holder = preload("res://Main/Player.tscn").instantiate()
		holder.set_customization(Cosmetic.generate_random())
		background.add_child(holder)
		holder.angular_velocity.x = 500
