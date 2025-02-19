extends Control

@export var background : Panel
@export var header : RichTextLabel
@export var player_info : RichTextLabel

func _ready() -> void:
	place_control()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("back"):
		Global.close_popup()

func place_control() -> void:
	background.set_size(Vector2(get_window().get_size().x / 1.25, get_window().get_size().y / 1.25))
	background.set_position(Vector2(get_window().get_size().x / 2 - background.size.x / 2, get_window().get_size().y / 2 - background.size.y / 2))
	
	header.set_size(background.size)
	header.add_theme_font_size_override("normal_font_size", 40 * get_window().get_size().x / 1280)
	header.set_position(Vector2(0, 10 * get_window().get_size().y / 720))
	
	player_info.set_size(background.size / 1.1)
	player_info.set_position(Vector2(background.size.x / 2 - player_info.size.x / 2, background.size.y / 30))

func set_data(playerdata : PlayerData) -> void:
	player_info.text = "\n\nHighest level reached: %d\n" % playerdata.highest_level
	player_info.text += "Amount of runs done: %d\n" % playerdata.game_over_count

func close_pressed() -> void:
	queue_free()
