extends Node

@onready var tilt_slider : HSlider = $ControlSettingsBox/TiltSens/HSplitContainer/TiltSlider
@onready var camera_slider : HSlider = $ControlSettingsBox/CameraSens/HSplitContainer/CameraSlider
@onready var deadzone_slider : HSlider = $ControlSettingsBox/Deadzone/HSplitContainer/DeadzoneSlider

@onready var tilt_value : RichTextLabel = $ControlSettingsBox/TiltSens/TiltSensValue
@onready var camera_value : RichTextLabel = $ControlSettingsBox/CameraSens/CameraSensValue
@onready var deadzone_value : RichTextLabel = $ControlSettingsBox/Deadzone/DeadzoneValue

@onready var red_slider : HSlider = $Red
@onready var blue_slider : HSlider = $Blue
@onready var green_slider : HSlider = $Green

var settings

func _ready() -> void:
	red_slider.value = PlayerInfo.player_data.player_color.r
	blue_slider.value = PlayerInfo.player_data.player_color.b
	green_slider.value = PlayerInfo.player_data.player_color.g
	
	settings = PlayerInfo.player_data.player_settings
	
	set_slider_values()

func _process(_delta: float) -> void:
	$TextureRect.texture = $SubViewport.get_texture()
	$SubViewport/MeshInstance3D.rotate_y(0.0001)


func set_slider_values() -> void:
	camera_slider.value = settings.camera_sens
	deadzone_slider.value = settings.tilt_deadzone


func tilt_sens_changed(value : float) -> void:
	tilt_value.text = "[center]" + str(snapped((value - tilt_slider.min_value)/tilt_slider.min_value * 2,0.01))

func camera_sens_changed(value: float) -> void:
	camera_value.text = "[center]" + str(snapped((value - camera_slider.min_value)/camera_slider.min_value * 2,0.01))

func deadzone_changed(value: float) -> void:
	deadzone_value.text = "[center]" + str(snapped((value / deadzone_slider.max_value), 0.01))

func red_changed(value: float) -> void:
	PlayerInfo.player_data.player_color.r = value
	$SubViewport/MeshInstance3D.mesh.material.albedo_color = PlayerInfo.player_data.player_color
	$SubViewport/MeshInstance3D/OmniLight3D.light_color = PlayerInfo.player_data.player_color

func blue_changed(value: float) -> void:
	PlayerInfo.player_data.player_color.b = value
	$SubViewport/MeshInstance3D.mesh.material.albedo_color = PlayerInfo.player_data.player_color
	$SubViewport/MeshInstance3D/OmniLight3D.light_color = PlayerInfo.player_data.player_color

func green_changed(value: float) -> void:
	PlayerInfo.player_data.player_color.g = value
	$SubViewport/MeshInstance3D.mesh.material.albedo_color = PlayerInfo.player_data.player_color
	$SubViewport/MeshInstance3D/OmniLight3D.light_color = PlayerInfo.player_data.player_color

func save_settings() -> void:
	settings.camera_sens = camera_slider.value
	settings.tilt_deadzone = deadzone_slider.value

func reset_settings() -> void:
	PlayerInfo.player_data.player_settings = Settings.new()
	set_slider_values()

func close_pressed() -> void:
	Global.main.close_settings()
	set_slider_values()
