extends Control

@onready var red_slider : HSlider = $VBoxContainer/Red
@onready var blue_slider : HSlider = $VBoxContainer/Blue
@onready var green_slider : HSlider = $VBoxContainer/Green

var playerdata : PlayerData

func _ready() -> void:
	red_slider.value = playerdata.player_color.r
	blue_slider.value = playerdata.player_color.b
	green_slider.value = playerdata.player_color.g

func _process(_delta: float) -> void:
	$VBoxContainer/TextureRect.texture = $SubViewport.get_texture()
	$SubViewport/MeshInstance3D.rotate_y(0.0001)
	
	if Input.is_action_just_pressed("back"):
		close_pressed()

func set_data(playerdata_in : PlayerData) -> void:
	playerdata = playerdata_in
	if playerdata.highest_level != 0: 
		$Label.text = "Highest level reached: %d" % playerdata.highest_level
	else:
		$Label.text = "Not played yet"

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

func close_pressed() -> void:
	queue_free()
