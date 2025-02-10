extends Node3D

@export var collider : CollisionShape3D

func respawn_player(area : Area3D) -> void:
	if area.get_parent() is player:
		Particle.spawn_reset_particle(area.global_position)
		Global.runBase.reset_marble()
		Global.runBase.reset_orientation()
