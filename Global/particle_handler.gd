extends Node

func spawn_reset_particle(pos : Vector3) -> void:
	var particle = preload("res://Assets/Particles/MarbleDisappear.tscn").instantiate()
	particle.mesh.material.albedo_color = PlayerInfo.player_data.player_color
	Global.current_scene.add_child(particle)
	particle.global_position = pos
	particle.get_children()[0].light_color = PlayerInfo.player_data.player_color
	particle.emitting = true
