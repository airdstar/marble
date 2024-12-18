extends Control

@onready var red_slider : HSlider = $VBoxContainer/Red
@onready var blue_slider : HSlider = $VBoxContainer/Blue
@onready var green_slider : HSlider = $VBoxContainer/Green

@onready var player_info : RichTextLabel = $Info

var playerdata : PlayerData
var is_own_profile : bool = false

func _ready() -> void:
	if is_own_profile:
		own_profile_opened()
	else:
		red_slider.visible = false
		blue_slider.visible = false
		green_slider.visible = false
	
	if playerdata.game_over_count != 0: 
		player_info.text = "Highest level reached: %d\n" % playerdata.highest_level
		player_info.text += "Amount of runs done: %d\n" % playerdata.game_over_count
	else:
		player_info.text = "Not played yet\n"

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("back"):
		close_pressed()

func set_data(playerdata_in : PlayerData) -> void:
	playerdata = playerdata_in
	if playerdata == PlayerInfo.player_data:
		is_own_profile = true

func own_profile_opened():
	red_slider.visible = true
	blue_slider.visible = true
	green_slider.visible = true
	
	red_slider.value = playerdata.player_color.r
	blue_slider.value = playerdata.player_color.b
	green_slider.value = playerdata.player_color.g

func red_changed(value: float) -> void:
	playerdata.player_color.r = value
	$VBoxContainer/TextureRect.modulate = playerdata.player_color

func blue_changed(value: float) -> void:
	playerdata.player_color.b = value
	$VBoxContainer/TextureRect.modulate = playerdata.player_color

func green_changed(value: float) -> void:
	playerdata.player_color.g = value
	$VBoxContainer/TextureRect.modulate = playerdata.player_color

func close_pressed() -> void:
	queue_free()
