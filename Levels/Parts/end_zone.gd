extends Node3D

func next_level(_area: Area3D) -> void:
	$Area3D.set_deferred("monitoring", false)
	RunInfo.clearedLevels += 1
	Global.runBase.points.text = "[center]" + str(RunInfo.clearedLevels)
	Global.runBase.state.next_level()
