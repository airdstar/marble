extends Node

var enable_play : bool = true
var enable_gallery : bool = false
#var enable_challenges : bool = false
#var enable_multiplayer : bool = false

func play_pressed() -> void:
	Global.main.start_run()

func gallery_pressed() -> void:
	Global.main.open_gallery()

func settings_pressed() -> void:
	Global.main.open_settings()
