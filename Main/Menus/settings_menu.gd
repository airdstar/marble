extends Node

func _ready() -> void:
	for n in Data.resolutions:
		%Resolutions.add_item(n)
	
	set_values()
	control_pressed()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("back"):
		Data.save_settings()
		Game.call_deferred("close_popup")

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
	%TiltSlider.value = Data.settings.tilt_sens
	%TiltBox.value = Data.settings.tilt_sens
	%CameraSlider.value = Data.settings.camera_sens
	%CameraBox.value = Data.settings.camera_sens
	
	%Resolutions.selected = Data.resolutions.keys().find(Data.settings.resolution)
	%Fullscreen.button_pressed = Data.settings.fullscreen
	%FPS.button_pressed = Data.settings.fps_display
	%Speed.button_pressed = Data.settings.speed_display

func tilt_sens_changed(value: float) -> void:
	%TiltBox.set_value_no_signal(value)
	%TiltSlider.set_value_no_signal(value)
	Data.settings.tilt_sens = value

func camera_sens_changed(value : float) -> void:
	%CameraBox.set_value_no_signal(value)
	%CameraSlider.set_value_no_signal(value)
	Data.settings.camera_sens = value

func resolution_selected(index: int) -> void:
	Data.settings.resolution = Data.resolutions.keys()[index]
	if !Data.settings.fullscreen:
		Game.set_resolution()

func fullscreen_toggled(toggled_on: bool) -> void:
	Data.settings.fullscreen = toggled_on
	Game.set_fullscreen()

func fps_toggled(toggled_on : bool) -> void:
	Data.settings.fps_display = toggled_on

func speed_toggled(toggled_on : bool) -> void:
	Data.settings.speed_display = toggled_on

func reset_settings() -> void:
	Data.clear_settings()
	Game.set_resolution()
	Game.set_fullscreen()
	set_values()
