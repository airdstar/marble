extends Node

var player_dummy : RigidBody3D
@export var dummy_display : TextureRect
@export var dummy_view : SubViewport

@export_category("Containers")
@export var option_container : VBoxContainer
@export var tab_container : HBoxContainer
@export var color_container : GridContainer
@export var face_container : GridContainer
@export var flair_container : GridContainer

func _ready() -> void:
	player_dummy = preload("res://Main/Player.tscn").instantiate()
	player_dummy.set_customization(PlayerInfo.player_data.player_customization)
	player_dummy.freeze = true
	dummy_view.add_child(player_dummy)
	
	tab_changed(0)
	place_control()
	for n in Cosmetic.colors:
		for m in Cosmetic.get_shades(n):
			var current_button : Button = create_button()
			color_container.add_child(current_button)
			current_button.modulate = m
			current_button.pressed.connect(set_color.bind(m))
	
	for n in Cosmetic.faces:
		var current_button : Button = create_button()
		current_button.icon = n
		face_container.add_child(current_button)
		current_button.pressed.connect(set_face.bind(n))

	
	for n in Cosmetic.flairs:
		var current_button = create_button()
		current_button.icon = n
		flair_container.add_child(current_button)
		current_button.pressed.connect(set_flair.bind(n))


func _process(delta: float) -> void:
	if Input.is_action_pressed("back"):
		Global.open_scene(Global.main_scene.prev_scene)
	player_dummy.rotate_y(0.5 * delta)

func place_control() -> void:
	
	option_container.set_size(Vector2(get_window().size.x / 2, get_window().size.y))
	option_container.set_position(Vector2(get_window().size.y / 20, 0))
	
	tab_container.custom_minimum_size = Vector2(get_window().size.x * 9 / 20, get_window().size.y / 10)
	
	dummy_view.set_size(Vector2(get_window().size.x / 4, get_window().size.x / 4))
	dummy_display.set_position(Vector2(get_window().size.x * 4 / 5 - dummy_view.size.x / 2, get_window().size.y * 3 / 6 - dummy_view.size.y / 2))

func create_button() -> Button:
	var to_return = Button.new()
	to_return.custom_minimum_size = Vector2(get_window().size.x / 11, get_window().size.x / 11)
	to_return.expand_icon = true
	return to_return

func tab_changed(index : int) -> void:
	color_container.visible = false
	face_container.visible = false
	flair_container.visible = false
	match index:
		0:
			color_container.visible = true
		1:
			face_container.visible = true
		2:
			flair_container.visible = true


func set_color(color : Color) -> void:
	PlayerInfo.player_data.player_customization.chosen_color = color
	PlayerInfo.save_data()
	player_dummy.set_color()
	player_dummy.rotation = Vector3.ZERO

func set_face(face : Texture2D) -> void:
	PlayerInfo.player_data.player_customization.chosen_face = face
	PlayerInfo.save_data()
	player_dummy.set_face()
	player_dummy.rotation = Vector3.ZERO

func set_flair(flair : Texture2D) -> void:
	PlayerInfo.player_data.player_customization.chosen_flair = flair
	PlayerInfo.save_data()
	player_dummy.set_flair()
	player_dummy.rotation = Vector3(0,deg_to_rad(180),0)
