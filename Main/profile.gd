extends Control

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("back"):
		close_pressed()

func set_data(playerdata : PlayerData) -> void:
	if playerdata.highest_level != 0: 
		$Label.text = "Highest level reached: %d" % playerdata.highest_level
	pass

func close_pressed() -> void:
	queue_free()
