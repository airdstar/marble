extends Node

@onready var camera_slider : HSlider = $CameraSlider
@onready var deadzone_slider : HSlider = $DeadzoneSlider

@onready var deadzone_label : RichTextLabel = $DeadzoneSlider/DeadzoneValue
@onready var camera_sens_label : RichTextLabel = $CameraSlider/CameraSensValue

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
	camera_slider.min_value = 60
	camera_slider.max_value = 90
	camera_slider.step = 0.5
	camera_slider.value = settings.camera_sens_keyboard
		
	deadzone_slider.min_value = 1
	deadzone_slider.max_value = 40
	deadzone_slider.step = 0.5
	deadzone_slider.value = settings.mouse_deadzone


func camera_sens_changed(value: float) -> void:
	settings.camera_sens_keyboard = value
	camera_sens_label.text = "[center]" + str(snapped((value - camera_slider.min_value)/camera_slider.min_value * 2,0.01))

func deadzone_changed(value: float) -> void:
	settings.mouse_deadzone = value
	deadzone_label.text = "[center]" + str(snapped((value / deadzone_slider.max_value), 0.01))

func close_pressed() -> void:
	Global.main.close_settings()

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
