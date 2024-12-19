extends Node

var enable_play : bool = true
var enable_gallery : bool = false
#var enable_challenges : bool = false
#var enable_multiplayer : bool = false

@onready var play : Button = $CenterContainer/VBoxContainer/Play
@onready var gallery : Button = $CenterContainer/VBoxContainer/Gallery

func _ready() -> void:
	pass

func play_pressed() -> void:
	RunInfo.current_difficulty = RunInfo.difficulty.EASY
	Global.main.start_run()

func play_test_pressed() -> void:
	RunInfo.current_difficulty = RunInfo.difficulty.TEST
	Global.main.start_run()

func gallery_pressed() -> void:
	Global.main.open_gallery()

func profile_pressed() -> void:
	add_child(PlayerInfo.player_data.open_profile())

func settings_pressed() -> void:
	var holder = preload("res://Main/SettingsMenu.tscn").instantiate()
	add_child(holder)
