extends Node

@export var background : Panel

@export_category("Containers")
@export var holding_container : VBoxContainer
@export var control_container : GridContainer
@export var visual_container : GridContainer
@export var accessability_container : GridContainer
@export var binds_container : GridContainer

@export_category("Buttons")
@export var tab_buttons : Array[Button]
@export var io_buttons : Array[Button]

@export_category("Non-specific control")
@export var values : Array[RichTextLabel]
@export var changers : Array[Control]

@export_category("Specific control")
@export var tilt_sens : Array[Control]
@export var camera_sens : Array[Control]
@export var deadzone : Array[Control]

@export var aspect_ratio : Array[Control]
@export var resolution : Array[Control]
@export var fullscreen : Array[Control]

@export var speed : Array[Control]
@export var fps : Array[Control]

func _ready() -> void:
	for n in Global.aspect_ratios:
		aspect_ratio[0].add_item(n)
	
	place_control()
	set_values()
	tab_changed(0)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("back"):
		Global.close_popup()

func place_control() -> void:
	background.set_size(Vector2(get_window().get_size().x / 1.25, get_window().get_size().y / 1.25))
	background.set_position(Vector2(get_window().get_size().x / 2 - background.size.x / 2, get_window().get_size().y / 2 - background.size.y / 2))
	
	holding_container.set_size(background.size / 1.1)
	holding_container.set_position(Vector2(background.size.x / 2 - holding_container.size.x / 2, background.size.y / 30))
	
	for n in tab_buttons:
		n.set_custom_minimum_size(Vector2(background.size.x / 10, background.size.y / 15))
	
	for n in io_buttons:
		n.set_custom_minimum_size(Vector2(background.size.x / 5, background.size.y / 10))
	
	for n in values:
		n.set_custom_minimum_size(Vector2(background.size.x / 10, 0))
	
	for n in changers:
		n.set_custom_minimum_size(Vector2(background.size.x * 3 / 5, 20 * get_window().get_size().x / 1280))

func tab_changed(index : int) -> void:
	control_container.visible = false
	visual_container.visible = false
	accessability_container.visible = false
	binds_container.visible = false
	
	match index:
		0:
			control_container.visible = true
		1:
			visual_container.visible = true
		2:
			accessability_container.visible = true
		3:
			binds_container.visible = true

func set_values() -> void:
	tilt_sens[0].value = (PlayerInfo.player_settings.tilt_sens * 100)
	camera_sens[0].value = PlayerInfo.player_settings.camera_sens
	deadzone[0].value = PlayerInfo.player_settings.tilt_deadzone
	
	if PlayerInfo.player_settings.fullscreen:
		fullscreen[0].button_pressed = true
	else:
		fullscreen[0].button_pressed = false
	
	visual_changed()
	
	for n in aspect_ratio[0].item_count:
		if aspect_ratio[0].get_item_text(n) == PlayerInfo.player_settings.aspect_ratio:
			aspect_ratio[0].selected = n
			set_res_options(n)
			break
	
	speed[0].button_pressed = PlayerInfo.player_settings.speed_display
	fps[0].button_pressed = PlayerInfo.player_settings.fps_display
	accessibility_changed()

func set_res_options(index : int) -> void:
	resolution[0].clear()
	var found_res : bool = false
	for n in Global.aspect_ratios[aspect_ratio[0].get_item_text(index)]:
		resolution[0].add_item(n)
		if n == PlayerInfo.player_settings.resolution:
			resolution[0].selected = resolution[0].item_count - 1
			found_res = true
	if !found_res:
		resolution[0].selected = 0

func control_changed(value : float, index : int) -> void:
	match index:
		0:
			tilt_sens[1].text = "[right]%.1f" % (value * 10)
		1:
			camera_sens[1].text = "[right]%.1f" % value
		2:
			deadzone[1].text = "[right]%.1f" % value

func visual_changed() -> void:
	aspect_ratio[1].text = "[right]" + PlayerInfo.player_settings.aspect_ratio
	resolution[1].text = "[right]" + PlayerInfo.player_settings.resolution
	if PlayerInfo.player_settings.fullscreen:
		fullscreen[1].text = "[right]Enabled"
	else:
		fullscreen[1].text = "[right]Disabled"

func accessibility_changed() -> void:
	if speed[0].button_pressed:
		speed[1].text = "[right]Enabled"
	else:
		speed[1].text = "[right]Disabled"
	
	if fps[0].button_pressed:
		fps[1].text = "[right]Enabled"
	else:
		fps[1].text = "[right]Disabled"

func save_settings() -> void:
	PlayerInfo.player_settings.tilt_sens = tilt_sens[0].value / 100
	PlayerInfo.player_settings.camera_sens = camera_sens[0].value
	PlayerInfo.player_settings.tilt_deadzone = deadzone[0].value
	PlayerInfo.player_settings.speed_display = speed[0].button_pressed
	PlayerInfo.player_settings.fps_display = fps[0].button_pressed
	
	accessibility_changed()
	if PlayerInfo.player_settings.resolution != resolution[0].get_item_text(resolution[0].selected):
		PlayerInfo.player_settings.aspect_ratio = aspect_ratio[0].get_item_text(aspect_ratio[0].selected)
		PlayerInfo.player_settings.resolution = resolution[0].get_item_text(resolution[0].selected)
		Global.set_resolution()
		visual_changed()
	
	if fullscreen[0].button_pressed != PlayerInfo.player_settings.fullscreen:
		PlayerInfo.player_settings.fullscreen = fullscreen[0].button_pressed
		Global.set_fullscreen()
		visual_changed()
	
	PlayerInfo.save_settings()

func reset_settings() -> void:
	PlayerInfo.player_settings = Settings.new()
	set_values()
