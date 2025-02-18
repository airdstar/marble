extends Control

@export var background : Panel
@export var player_info : RichTextLabel

func _ready() -> void:
	place_control()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("back"):
		Global.close_popup()

func place_control() -> void:
	background.set_size(Vector2(get_window().get_size().x / 1.25, get_window().get_size().y / 1.25))
	background.set_position(Vector2(get_window().get_size().x / 2 - background.size.x / 2, get_window().get_size().y / 2 - background.size.y / 2))
	
	player_info.set_size(background.size / 1.1)
	player_info.set_position(Vector2(background.size.x / 2 - player_info.size.x / 2, background.size.y / 30))

func set_data(playerdata : PlayerData) -> void:
	player_info.text = "[center][font_size=40]Player Stats[/font_size][/center]\n"
	if playerdata.game_over_count != 0: 
		player_info.text += "Highest level reached: %d\n" % playerdata.highest_level
		player_info.text += "Amount of runs done: %d\n" % playerdata.game_over_count
	else:
		player_info.text += "Not played yet\n"

func close_pressed() -> void:
	queue_free()
