extends Node

var enable_play : bool = true
var enable_gallery : bool = false
#var enable_challenges : bool = false
#var enable_multiplayer : bool = false

@onready var play : Button = $VBoxContainer/Play
@onready var gallery : Button = $VBoxContainer/Gallery
@onready var settings : Button = $VBoxContainer/Settings

func _ready() -> void:
	pass

func play_pressed() -> void:
	Global.main.start_run()

func gallery_pressed() -> void:
	Global.main.open_gallery()

func settings_pressed() -> void:
	Global.main.open_settings()
