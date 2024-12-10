extends Node3D

func _ready() -> void:
	$Particles.mesh.material.albedo_color = PlayerInfo.player_data.player_color

func respawn_marble(_area : Area3D) -> void:
	$Particles.emitting = true
	Global.runBase.reset_marble()
	Global.runBase.reset_orientation()
