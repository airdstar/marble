extends Control

@onready var player_info : RichTextLabel = $Info

var playerdata : PlayerData
var is_own_profile : bool = false

func _ready() -> void:
	
	if playerdata.game_over_count != 0: 
		player_info.text = "Highest level reached: %d\n" % playerdata.highest_level
		player_info.text += "Amount of runs done: %d\n" % playerdata.game_over_count
	else:
		player_info.text = "Not played yet\n"

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("back"):
		Global.close_popup()

func set_data(playerdata_in : PlayerData) -> void:
	playerdata = playerdata_in
	if playerdata == PlayerInfo.player_data:
		is_own_profile = true

func close_pressed() -> void:
	queue_free()
