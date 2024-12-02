extends Node3D

func _ready() -> void:
	$EndParticles.mesh.material.albedo_color = PlayerInfo.player_data.player_color

func next_level(_area: Area3D) -> void:
	$EndParticles.emitting = true
	$Area3D.set_deferred("monitoring", false)
	RunInfo.clearedLevels += 1
	Global.runBase.points.text = "[center]" + str(RunInfo.clearedLevels)
	Global.runBase.next_level()
