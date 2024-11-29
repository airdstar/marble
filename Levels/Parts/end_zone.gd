extends Node3D

func _ready() -> void:
	$EndParticles.mesh.material.albedo_color = PlayerInfo.player_color

func next_level(_area: Area3D) -> void:
	$EndParticles.emitting = true
	$Area3D.set_deferred("monitoring", false)
	RunInfo.clearedLevels += 1
	match RunInfo.currentDifficulty:
		0:
			RunInfo.points_earned += 1
		1:
			RunInfo.points_earned += 3
		2:
			RunInfo.points_earned += 7
		3:
			pass
	
	Global.runBase.points.text = "[center]" + str(RunInfo.clearedLevels)
	Global.runBase.next_level()
