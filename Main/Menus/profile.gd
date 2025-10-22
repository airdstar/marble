extends Control

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("back"):
		Global.close_popup()

func set_data(playerdata : PlayerData) -> void:
	%Runs.text = str(playerdata.game_over_count)
	%Highest.text = str(playerdata.highest_level)

func close_pressed() -> void:
	queue_free()
