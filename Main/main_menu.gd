extends Node

var enable_play : bool = true
var enable_gallery : bool = false
#var enable_challenges : bool = false
#var enable_multiplayer : bool = false

@onready var play_container : VBoxContainer = $PlayContainer

func _ready() -> void:
	place_control()

func place_control() -> void:
	play_container.call_deferred("set_size", Vector2(get_window().get_size().x / 7, get_window().get_size().y * 5 / 6))
	play_container.call_deferred("set_position", Vector2(get_window().get_size().x / 2.25, 0))
	

func play_pressed() -> void:
	RunInfo.current_difficulty = RunInfo.difficulty.EASY
	Global.main.start_run()

func play_test_pressed() -> void:
	RunInfo.current_difficulty = RunInfo.difficulty.TEST
	Global.main.start_run()

func gallery_pressed() -> void:
	Global.open_scene(main.possible_scenes.GALLERY)

func editor_pressed() -> void:
	Global.open_scene(main.possible_scenes.EDITOR)

func profile_pressed() -> void:
	add_child(PlayerInfo.player_data.open_profile())

func settings_pressed() -> void:
	Global.open_scene(main.possible_scenes.SETTINGS)

func exit_pressed() -> void:
	get_tree().quit()
