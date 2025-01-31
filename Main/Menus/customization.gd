extends Node


@export var pos_colors : Array[Color] 

var face_path : String = "res://Assets/Customization/Faces/"
var marking_path : String = "res://Assets/Customization/Markings/"

@export var player_dummy : RigidBody3D

@export_category("Containers")
@export var color_container : VBoxContainer
@export var face_container : VBoxContainer
@export var marking_container : VBoxContainer



func _ready() -> void:
	player_dummy.freeze = true
	for n in pos_colors:
		var current_button = Button.new()
		current_button.modulate = n
		current_button.text = "Color"
		color_container.add_child(current_button)
		current_button.pressed.connect(set_color.bind(n))
	
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
		var current_button = Button.new()
		current_button.icon = holder
		current_button.expand_icon = true
		current_button.custom_minimum_size = Vector2(32,32)
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
		
		var holder = ResourceLoader.load(face_path + current_marking)
		var current_button = Button.new()
		current_button.icon = holder
		current_button.expand_icon = true
		current_button.custom_minimum_size = Vector2(32,32)
		marking_container.add_child(current_button)
		current_button.pressed.connect(set_marking.bind(current_marking))
		current_marking = dir.get_next()
	dir.list_dir_end()
	

func _process(delta: float) -> void:
	if Input.is_action_pressed("back"):
		Global.open_scene(Global.main_scene.prev_scene)
	player_dummy.rotate_y(1 * delta)
	$TextureRect.texture = $SubViewport.get_texture()

func set_color(color : Color) -> void:
	PlayerInfo.player_data.player_customization.chosen_color = color
	PlayerInfo.save_data()
	player_dummy.set_color()

func set_face(face : String) -> void:
	PlayerInfo.player_data.player_customization.chosen_face = face
	PlayerInfo.save_data()
	player_dummy.set_face()

func set_marking(marking : String) -> void:
	PlayerInfo.player_data.player_customization.chosen_marking = marking
	PlayerInfo.save_data()
	player_dummy.set_marking()
