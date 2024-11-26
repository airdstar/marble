extends Node3D

@onready var camera = $Camera3D

func _ready():
	pass

func _process(delta: float) -> void:
	var camera_input = Input.get_axis("camera_left", "camera_right")
		
	if (camera_input != 0):
		match Settings.control_type:
			0:
				rotate_y(deg_to_rad(camera_input * Settings.camera_sens_keyboard) * delta)
			1:
				rotate_y(deg_to_rad(camera_input * Settings.camera_sens_controller) * delta)


func rand_rotation(lowerbound : float, upperbound : float):
	var rotationAmount = deg_to_rad(randf_range(lowerbound, upperbound))
	rotationAmount -= deg_to_rad(fmod(rad_to_deg(Global.runBase.camera.rotation.y), 360))
	
	var tween = create_tween()
	tween.tween_property(self, "rotation", self.rotation + Vector3(0,rotationAmount + 2,0), 1.5).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
