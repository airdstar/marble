extends Node3D

@export var size : Vector3 = Vector3(1,0.1,1)
@export var movement : Vector3 = Vector3.ZERO

@export var movementTime : float = 1.5
@export var downTime : float = 1
@export var playerReliant : bool = true

var startPos : Vector3

func _ready():
	$MeshInstance3D.mesh.size = size
	$Area3D/CollisionShape3D.shape.size = Vector3(0.7 * size.x, 0.3, 0.7 * size.z)
	$MeshInstance3D.create_trimesh_collision()
	startPos = position
	if !playerReliant:
		$Area3D.set_deferred("monitoring", false)
		move_object()

func move_object():
	var tween = create_tween()
	tween.tween_property(self, "position", movement, movementTime)
	await get_tree().create_timer(movementTime + 0.01).timeout
	await get_tree().create_timer(downTime).timeout
	tween = create_tween()
	tween.tween_property(self, "position", startPos, movementTime)
	await get_tree().create_timer(movementTime + 0.01).timeout
	if playerReliant:
		$Area3D.set_deferred("monitoring", true)
	else:
		move_object()

func trigger_movement(_area: Area3D) -> void:
	move_object()
	$Area3D.set_deferred("monitoring", false)
