extends Node3D

func next_level(_area: Area3D) -> void:
	RunInfo.clearedLevels += 1
	RunInfo.floor.points.text = "[center]" + str(RunInfo.clearedLevels)
	RunInfo.floor.state.next_level()
