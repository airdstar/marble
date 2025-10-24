extends Node

var scene : Node
var popup : Node

func set_resolution() -> void:
	get_window().set_size(Data.resolutions[PlayerInfo.player_settings.resolution])
	var screen_center = DisplayServer.screen_get_position() + DisplayServer.screen_get_size() / 2
	var window_size = get_window().get_size_with_decorations()
	get_window().set_position(screen_center - window_size / 2)

func set_fullscreen() -> void:
	if Data.data.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func open_scene(path : String) -> void:
	if !FileAccess.file_exists(path):
		return
	if scene != null:
		scene.queue_free()
	
	var holder = load(path)
	scene = holder.instantiate()
	add_child(scene)

func open_popup(path : String) -> void:
	if !FileAccess.file_exists(path):
		close_popup()
		var holder = load(path)
		popup = holder.instantiate()
		add_child(popup)
		

func close_popup() -> void:
	if popup:
		popup.queue_free()
	popup = null

func open_profile(player_info : PlayerData) -> void:
	open_popup("res://Main/Menus/Profile.tscn")
	popup.set_data(player_info)

func play() -> void:
	open_scene("res://Levels/Handlers/Floor.tscn")
	scene.is_run = true
	scene.allow_timer = true
	
	scene.call_deferred("start_game")

func test(level : level_resource) -> void:
	open_scene("res://Levels/Handlers/Floor.tscn")
