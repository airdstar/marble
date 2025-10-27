extends Node

func spawn_reset_particle(pos : Vector3) -> void:
	var particle = preload("res://Assets/Particles/MarbleDisappear.tscn").instantiate()
	particle.mesh.material.albedo_color = Data.data.player_customization.chosen_color
	add_child(particle)
	particle.global_position = pos
	particle.get_children()[0].light_color = Data.data.player_customization.chosen_color
	particle.emitting = true
