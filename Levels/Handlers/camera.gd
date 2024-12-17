extends Node3D

@onready var camera = $Camera3D

var skybox : Environment
var settings = PlayerInfo.player_settings
var allow_input : bool = true

func _ready():
	pass

func _process(delta: float) -> void:
	if allow_input:
		var camera_input = Input.get_axis("camera_left", "camera_right")
		
		if (camera_input != 0):
			
			match settings.control_type:
				0:
					rotate_y(deg_to_rad(camera_input * settings.camera_sens) * delta)
					skybox.sky_rotation += Vector3(0, deg_to_rad(camera_input * settings.camera_sens) * delta, 0)
				1:
					rotate_y(deg_to_rad(camera_input * settings.camera_sens_controller) * delta)
					skybox.sky_rotation += Vector3(0, deg_to_rad(camera_input * settings.camera_sens) * delta, 0)

func rand_rotation(lowerbound : float, upperbound : float):
	var rotationAmount = deg_to_rad(randf_range(lowerbound, upperbound))
	rotationAmount -= deg_to_rad(fmod(rad_to_deg(Global.runBase.camera.rotation.y), 360))
	
	var tween = create_tween()
	tween.tween_property(self, "rotation", self.rotation + Vector3(0,rotationAmount + 2,0), 1.5).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)

func next_level():
	
	var tween = create_tween()
	tween.tween_property(self, "position", Vector3(0,-250,0), 0.7).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	
	await get_tree().create_timer(0.1).timeout
	var skyboxTween = create_tween()
	skyboxTween.tween_property(skybox, "sky_rotation", skybox.sky_rotation * (Vector3(4,0,0)), 0.8).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	
	await get_tree().create_timer(0.61).timeout
	
	position = Vector3(0,55,0)
	tween = create_tween()
	tween.tween_property(self, "position", Vector3(0,6,0), 0.2).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
