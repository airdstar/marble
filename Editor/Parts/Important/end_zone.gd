extends Node3D
class_name endzone

@export var collider : CollisionShape3D

func next_level(area: Area3D) -> void:
	if area.get_parent() is player:
		Particle.spawn_reset_particle(area.global_position)
		area.set_deferred("monitorable", false)
		Global.runBase.next_level()
