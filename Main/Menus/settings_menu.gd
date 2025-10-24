extends Node

func _ready() -> void:
	set_values()
	control_pressed()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("back"):
		Global.close_popup()

func control_pressed() -> void:
	%ControlButton.disabled = true
	%ControlContainer.show()
	
	%VisualButton.disabled = false
	%VisualContainer.hide()

func visual_pressed() -> void:
	%VisualButton.disabled = true
	%VisualContainer.show()
	
	%ControlButton.disabled = false
	%ControlContainer.hide()

func set_values() -> void:
	%TiltSlider.value = PlayerInfo.player_settings.tilt_sens
	%TiltBox.value = PlayerInfo.player_settings.tilt_sens
	%CameraSlider.value = PlayerInfo.player_settings.camera_sens
	%CameraBox.value = PlayerInfo.player_settings.camera_sens
	
	
	%Fullscreen.button_pressed = PlayerInfo.player_settings.fullscreen
	%FPS.button_pressed = PlayerInfo.player_settings.fps_display
	%Speed.button_pressed = PlayerInfo.player_settings.speed_display

func tilt_sens_changed(value: float) -> void:
	%TiltBox.set_value_no_signal(value)
	%TiltSlider.set_value_no_signal(value)
	PlayerInfo.player_settings.tilt_sens = value

func camera_sens_changed(value : float) -> void:
	%CameraBox.set_value_no_signal(value)
	%CameraSlider.set_value_no_signal(value)
	PlayerInfo.player_settings.camera_sens = value

func reset_settings() -> void:
	PlayerInfo.player_settings = Settings.new()
	set_values()
