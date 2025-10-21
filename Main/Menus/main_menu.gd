extends Node

@export var main_container : GridContainer
@export var extras_container : GridContainer
@export var important_container : HBoxContainer
@export var logo : Sprite2D

@export var background : SubViewport


func _ready() -> void:
	set_background()

func _process(delta: float) -> void:
	$Logo.rotation = ($Logo.rotation + 0.3 * delta)

func open_floor() -> void:
	Global.open_floor(FloorLevel.floor_type.PLAY, [])

func open_scene(scene_name : String) -> void:
	Global.open_scene(scene_name)

func open_popup(popup_name : String) -> void:
	Global.open_popup(popup_name)

func open_profile() -> void:
	Global.open_profile(PlayerInfo.player_data)


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
