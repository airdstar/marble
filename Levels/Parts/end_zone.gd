extends Node3D
class_name endzone

@export var disable_front : bool = false
@export var disable_back : bool = false

func _ready() -> void:
	#$EndParticles.mesh.material.albedo_color = PlayerInfo.player_data.player_color
	pass

func next_level(area: Area3D) -> void:
	if area.get_parent() is player:
		$Area3D.set_deferred("monitoring", false)
	
		if Global.runBase is play_floor:
			RunInfo.current_level += 1
			#Global.runBase.points.text = "[center]" + str(RunInfo.current_level)
			if RunInfo.current_level % 10 == 0:
				Global.runBase.ramp_up()
		Global.runBase.next_level()

func reset_state() -> void:
	$Area3D.set_deferred("monitoring", true)
