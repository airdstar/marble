extends Node

func _ready() -> void:
	%Play.pressed.connect(Game.play)
	%Player.pressed.connect(Game.open_profile.bind(Data.data))
	%Settings.pressed.connect(Game.open_popup.bind("res://Main/Menus/SettingsMenu.tscn"))

func _process(delta: float) -> void:
	$Logo.rotation = ($Logo.rotation + 0.3 * delta)
	if Input.is_action_just_pressed("back") and !Game.popup:
		get_tree().quit()
	
	if Input.is_action_just_pressed("dev"):
		Game.open_scene("res://Editor/LevelEditor.tscn")
	
