extends Node

@export var pos_colors : Array[Color] 

var face_path : String = "res://Assets/Customization/Faces/"
var marking_path : String = "res://Assets/Customization/Markings/"

@export var player_dummy : RigidBody3D
@export var dummy_display : TextureRect
@export var dummy_view : SubViewport

@export_category("Containers")
@export var option_container : VBoxContainer
@export var color_container : GridContainer
@export var face_container : GridContainer
@export var marking_container : GridContainer

func _ready() -> void:
	tab_changed(0)
	place_control()
	for n in pos_colors:
		for m in 5:
			var current_button : Button = create_button()
			color_container.add_child(current_button)
			match m:
				0:
					current_button.modulate = n.lightened(0.6)
					current_button.pressed.connect(set_color.bind(n.lightened(0.6)))
				1:
					current_button.modulate = n.lightened(0.3)
					current_button.pressed.connect(set_color.bind(n.lightened(0.3)))
				2:
					current_button.modulate = n
					current_button.pressed.connect(set_color.bind(n))
				3:
					current_button.modulate = n.darkened(0.3)
					current_button.pressed.connect(set_color.bind(n.darkened(0.3)))
				4:
					current_button.modulate = n.darkened(0.6)
					current_button.pressed.connect(set_color.bind(n.darkened(0.6)))
	
	var dir = DirAccess.open(face_path)
	dir.list_dir_begin()
	var current_face : String = dir.get_next()
	while current_face != "":
		if '.remap' in current_face:
			current_face = current_face.trim_suffix('.remap')
		
		if '.import' in current_face:
			current_face = dir.get_next()
			continue
		
		var holder = ResourceLoader.load(face_path + current_face)
		var current_button = create_button()
		current_button.icon = holder
		face_container.add_child(current_button)
		current_button.pressed.connect(set_face.bind(current_face))
		current_face = dir.get_next()
	dir.list_dir_end()
	
	dir = DirAccess.open(marking_path)
	dir.list_dir_begin()
	var current_marking : String = dir.get_next()
	while current_marking != "":
		if '.remap' in current_marking:
			current_marking = current_marking.trim_suffix('.remap')
		
		if '.import' in current_marking:
			current_marking = dir.get_next()
			continue
		
		var holder = ResourceLoader.load(marking_path + current_marking)
		var current_button = create_button()
		current_button.icon = holder
		marking_container.add_child(current_button)
		current_button.pressed.connect(set_marking.bind(current_marking))
		current_marking = dir.get_next()
	dir.list_dir_end()

func _process(delta: float) -> void:
	if Input.is_action_pressed("back"):
		Global.open_scene(Global.main_scene.prev_scene)
	player_dummy.rotate_y(0.5 * delta)

func place_control() -> void:
	
	option_container.set_size(Vector2(get_window().size.x / 2, get_window().size.y / 1.2))
	option_container.set_position(Vector2(get_window().size.y / 20, get_window().size.y / 20))
	
	dummy_view.set_size(Vector2(get_window().size.x / 4, get_window().size.x / 4))
	dummy_display.set_position(Vector2(get_window().size.x * 4 / 5 - dummy_view.size.x / 2, get_window().size.y * 3 / 6 - dummy_view.size.y / 2))

func create_button() -> Button:
	var to_return = Button.new()
	to_return.custom_minimum_size = Vector2(get_window().size.x / 12, get_window().size.x / 12)
	to_return.expand_icon = true
	return to_return

func tab_changed(index : int) -> void:
	color_container.visible = false
	face_container.visible = false
	marking_container.visible = false
	match index:
		0:
			color_container.visible = true
		1:
			face_container.visible = true
		2:
			marking_container.visible = true


func set_color(color : Color) -> void:
	PlayerInfo.player_data.player_customization.chosen_color = color
	PlayerInfo.save_data()
	player_dummy.set_color()
	player_dummy.rotation = Vector3.ZERO

func set_face(face : String) -> void:
	PlayerInfo.player_data.player_customization.chosen_face = face
	PlayerInfo.save_data()
	player_dummy.set_face()
	player_dummy.rotation = Vector3.ZERO

func set_marking(marking : String) -> void:
	PlayerInfo.player_data.player_customization.chosen_marking = marking
	PlayerInfo.save_data()
	player_dummy.set_marking()
	player_dummy.rotation = Vector3.ZERO
