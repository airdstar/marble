extends Node

var enable_play : bool = true
var enable_gallery : bool = false
#var enable_challenges : bool = false
#var enable_multiplayer : bool = false

var settings_menu

@onready var play : Button = $CenterContainer/VBoxContainer/Play
@onready var gallery : Button = $CenterContainer/VBoxContainer/Gallery
@onready var settings : Button = $CenterContainer/VBoxContainer/Settings

func _ready() -> void:
	settings_menu = preload("res://Main/SettingsMenu.tscn").instantiate()
	add_child(settings_menu)
	settings_menu.visible = false

func play_pressed() -> void:
	RunInfo.current_difficulty = RunInfo.difficulty.EASY
	Global.main.start_run()

func play_test_pressed() -> void:
	RunInfo.current_difficulty = RunInfo.difficulty.TEST
	Global.main.start_run()

func gallery_pressed() -> void:
	Global.main.open_gallery()

func settings_pressed() -> void:
	settings_menu.set_slider_values()
	settings_menu.visible = true
	hide_all()

func hide_all() -> void:
	play.visible = false
	gallery.visible = false
	settings.visible = false

func show_all() -> void:
	play.visible = true
	gallery.visible = true
	settings.visible = true
