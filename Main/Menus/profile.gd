extends Control

var player_dummy : player

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("back"):
		Global.close_popup()
	
	if player_dummy != null:
		player_dummy.rotate_y(0.5 * delta)

func set_data(playerdata : PlayerData) -> void:
	%Runs.text = str(playerdata.game_over_count)
	%Highest.text = str(playerdata.highest_level)
	player_dummy = preload("res://Main/Player.tscn").instantiate()
	player_dummy.set_customization(playerdata.player_customization)
	player_dummy.freeze = true
	$SubViewport.add_child(player_dummy)

func close_pressed() -> void:
	queue_free()
