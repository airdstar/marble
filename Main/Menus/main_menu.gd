extends Node

func _process(delta: float) -> void:
	$Logo.rotation = ($Logo.rotation + 0.3 * delta)
	if Input.is_action_just_pressed("back") and !Game.popup:
		get_tree().quit()

func open_floor() -> void:
	Game.play()

func open_scene(path : String) -> void:
	Game.open_scene(path)

func open_popup(path : String) -> void:
	Game.open_popup(path)

func open_profile() -> void:
	Game.open_profile(Data.data)
