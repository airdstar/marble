extends Control

@export var background : Panel
@export var header : RichTextLabel
@export var player_info : RichTextLabel

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("back"):
		Global.close_popup()

func set_data(playerdata : PlayerData) -> void:
	player_info.text = "\n\nHighest level reached: %d\n" % playerdata.highest_level
	player_info.text += "Amount of runs done: %d\n" % playerdata.game_over_count

func close_pressed() -> void:
	queue_free()
