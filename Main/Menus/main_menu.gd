extends Node

func _process(delta: float) -> void:
	$Logo.rotation = ($Logo.rotation + 0.3 * delta)
	if Input.is_action_just_pressed("back") and Global.

func open_floor() -> void:
	Global.open_floor(FloorLevel.floor_type.PLAY, [])

func open_scene(scene_name : String) -> void:
	Global.open_scene(scene_name)

func open_popup(popup_name : String) -> void:
	Global.open_popup(popup_name)

func open_profile() -> void:
	Global.open_profile(PlayerInfo.player_data)
