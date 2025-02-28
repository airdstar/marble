extends component
class_name moveable_component

@export_category("Movement")
@export var movement : Vector3 = Vector3.ZERO
@export var movement_time : float = 1.5
@export var down_time : float = 1

@export_category("Interactability")
@export var playerReliant : bool = false

@export var trigger_pos : Vector3 = Vector3(0,0.4,0)
@export var trigger_size : Vector3 = Vector3(3,1,1.5)

@export_category("Fixes")
@export var disable_collision_below : bool = true

var area : Area3D
var to_move : Node3D
var base : Node3D

var platform_collision : CollisionShape3D

func _ready():
	to_move = get_parent()
	if to_move is RigidBody3D:
		to_move.freeze = true
		platform_collision = to_move.get_node("MeshInstance3D").get_node("StaticBody3D").get_node("CollisionShape3D")
	base = to_move.get_parent()
	if playerReliant:
		area = Area3D.new()
		to_move.add_child.call_deferred(area)
		area.area_entered.connect(trigger_movement)
		var collision = CollisionShape3D.new()
		var collisionShape = BoxShape3D.new()
		collisionShape.set_size(trigger_size)
		collision.shape = collisionShape
		area.add_child(collision)
		collision.position = trigger_pos
	else:
		move_object()

func _physics_process(_delta : float) -> void:
	if disable_collision_below:
		if Global.runBase.marble.position.y < to_move.global_position.y:
			platform_collision.disabled = true
		else:
			platform_collision.disabled = false

func move_object():
	if !playerReliant:
		await get_tree().create_timer(down_time).timeout
	var tween = create_tween()
	tween.tween_property(to_move, "position", base.transform * (to_move.position + movement), movement_time)
	await get_tree().create_timer(movement_time + 0.01).timeout
	await get_tree().create_timer(down_time).timeout
	
	tween = create_tween()
	tween.tween_property(to_move, "position", base.transform * (to_move.position - movement), movement_time)
	await get_tree().create_timer(movement_time + 0.01).timeout
	if playerReliant:
		area.set_deferred("monitoring", true)
	else:
		move_object()

func trigger_movement(_area: Area3D) -> void:
	move_object()
	area.set_deferred("monitoring", false)
