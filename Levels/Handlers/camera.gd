extends Node3D

@export var panels : Node3D
@export var camera : Camera3D

var settings = PlayerInfo.player_settings
var allow_input : bool = true

func _process(delta: float) -> void:
	if allow_input:
		var camera_input = Input.get_axis("camera_left", "camera_right")
		if (camera_input != 0):
			rotate_y(deg_to_rad(camera_input * settings.camera_sens) * delta)
			panels.rotate_y(deg_to_rad(camera_input * settings.camera_sens) * delta)

func rand_rotation():
	var rotationAmount = deg_to_rad(randf_range(90, 360))
	rotationAmount -= deg_to_rad(fmod(rad_to_deg(rotation.y), 360))
	
	var tween = create_tween()
	tween.tween_property(self, "rotation", self.rotation + Vector3(0,rotationAmount + 2,0), 1.5).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
	
	var panel_tween = create_tween()
	panel_tween.tween_property(panels, "rotation", panels.rotation + Vector3(0,rotationAmount + 2,0), 1.5).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)

func next_level():
	
	var tween = create_tween()
	tween.tween_property(self, "position", Vector3(0,-250,0), 0.7).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	
	await get_tree().create_timer(0.71).timeout
	
	position = Vector3(0,100,0)
	tween = create_tween()
	tween.tween_property(self, "position", Vector3(0,0,0), 0.3).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
