extends Node

@export var main_container : HBoxContainer
@export var extras_container : VBoxContainer
@export var important_container : HBoxContainer
@export var logo : Sprite2D
@export var rotate_logo : Sprite2D

@export var background : SubViewport

@export var small_buttons : Array[Button]

var extras_opened : bool = false

func _ready() -> void:
	place_control()
	set_background()

func place_control() -> void:
	main_container.set_size(Vector2(get_window().get_size().x / 3, get_window().get_size().y / 10))
	main_container.set_position(Vector2(get_window().get_size().x / 2 - (main_container.size.x / 2), get_window().get_size().y / 2 + get_window().get_size().y / 10))
	
	extras_container.set_size(Vector2(get_window().get_size().x / 3, get_window().get_size().y * 5 / 20))
	extras_container.set_position(Vector2(get_window().get_size().x / 2 - (extras_container.size.x / 2), get_window().get_size().y / 2))
	
	
	for n : Button in small_buttons:
		n.set_custom_minimum_size(Vector2(get_window().get_size().y / 15, get_window().get_size().y / 15))
	important_container.set_size(Vector2.ZERO)
	important_container.set_position(Vector2(get_window().get_size().x / 2 - (important_container.size.x / 2), get_window().get_size().y * 9 / 10 - important_container.size.y) )
	
	
	logo.set_scale(Vector2(float(get_window().get_size().x) / 4000, float(get_window().get_size().x) / 4000))
	logo.set_position(Vector2(get_window().get_size().x / 2, get_window().get_size().y / 4))
	
	background.set_size(get_window().get_size())

func _process(delta: float) -> void:
	rotate_logo.rotation = (rotate_logo.rotation + 0.3 * delta)
	
	if Input.is_action_just_pressed("back"):
		if Global.main_scene.popup_scene == null:
			if !extras_opened:
				get_tree().quit()
			else:
				extras_opened = false
				main_container.visible = true
				extras_container.visible = false

func open_floor() -> void:
	Global.open_floor(FloorLevel.floor_type.PLAY, [])

func open_scene(scene_name : String) -> void:
	Global.open_scene(scene_name)

func open_popup(popup_name : String) -> void:
	Global.open_popup(popup_name)

func open_profile() -> void:
	Global.open_profile(PlayerInfo.player_data)

func extras_pressed() -> void:
	extras_opened = true
	main_container.visible = false
	extras_container.visible = true


func set_background() -> void:
	var holder
	while(true):
		await get_tree().create_timer(0.1).timeout
		holder = preload("res://Main/Player.tscn").instantiate()
		holder.set_customization(Cosmetic.generate_random())
		background.add_child(holder)
		holder.rotation = Vector3(randf_range(0,6), randf_range(0,6), randf_range(0,6))
		holder.angular_damp = 0
		match randi_range(0,3):
			0:
				holder.constant_torque = Vector3(randf_range(10, 15), 0, randf_range(-5, 5))
				holder.position.z = -16
				holder.position.x = randf_range(-16,16)
			1:
				holder.constant_torque = Vector3(randf_range(-15, -10), 0, randf_range(-5, 5))
				holder.position.z = 16
				holder.position.x = randf_range(-16,16)
			2:
				holder.constant_torque = Vector3(randf_range(-5, 5), 0, randf_range(10, 15))
				holder.position.x = 16
				holder.position.z = randf_range(-16,16)
			3:
				holder.constant_torque = Vector3(randf_range(-5, 5), 0, randf_range(-15, -10))
				holder.position.x = -16
				holder.position.z = randf_range(-16,16)

func cull_dummy(body: Node3D) -> void:
	body.queue_free()
