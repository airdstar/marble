extends Node3D

@export var movement : Vector3 = Vector3.ZERO

@export var movementTime : float = 1.5
@export var downTime : float = 1
@export var playerReliant : bool = true

var area : Area3D

func _ready():
	self.freeze = true
	$MeshInstance3D.create_trimesh_collision()
	if playerReliant:
		area = Area3D.new()
		add_child(area)
		area.area_entered.connect(trigger_movement)
		var collision = CollisionShape3D.new()
		var collisionShape = BoxShape3D.new()
		collisionShape.set_size(Vector3(0.7 * $MeshInstance3D.mesh.size.x, 0.3, 0.7 * $MeshInstance3D.mesh.size.z))
		collision.shape = collisionShape
		collision.position.y += 0.4
		area.add_child(collision)
	else:
		move_object()

func move_object():
	if !playerReliant:
		await get_tree().create_timer(downTime).timeout
	var tween = create_tween()
	tween.tween_property(self, "position", self.position + movement, movementTime)
	await get_tree().create_timer(movementTime + 0.01).timeout
	await get_tree().create_timer(downTime).timeout
	tween = create_tween()
	tween.tween_property(self, "position", self.position - movement, movementTime)
	await get_tree().create_timer(movementTime + 0.01).timeout
	if playerReliant:
		area.set_deferred("monitoring", true)
	else:
		move_object()

func trigger_movement(_area: Area3D) -> void:
	move_object()
	area.set_deferred("monitoring", false)
