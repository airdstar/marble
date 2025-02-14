extends Control

@export var background : Panel


@export var player_info : RichTextLabel

func _ready() -> void:
	place_control()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("back"):
		Global.close_popup()

func place_control() -> void:
	pass

func set_data(playerdata : PlayerData) -> void:
	if playerdata.game_over_count != 0: 
		player_info.text = "Highest level reached: %d\n" % playerdata.highest_level
		player_info.text += "Amount of runs done: %d\n" % playerdata.game_over_count
	else:
		player_info.text = "Not played yet\n"

func close_pressed() -> void:
	queue_free()
