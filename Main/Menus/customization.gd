extends Node

@export var color_container : VBoxContainer
@export var face_container : VBoxContainer
@export var marking_container : VBoxContainer


var pos_colors : Array[Color] = [
	Color(0.9, 0, 0), Color(0, 0.9, 0), Color(0, 0, 0.9),
	Color(0.9, 0.9, 0), Color(0.9, 0, 0.9), Color(0, 0.9, 0.9),
	Color(0.9, 0.9, 0.9), Color(0.1, 0.1, 0.1)
]

var face_path : String = "res://Assets/Customization/Faces/"
var marking_path : String = "res://Assets/Customization/Markings/"


func _ready() -> void:
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
		
		marking_container.add_child(current_button)
		current_button.pressed.connect(set_face.bind(current_marking))
		current_marking = dir.get_next()
	dir.list_dir_end()
	
	

func _process(_delta: float) -> void:
	if Input.is_action_pressed("back"):
		Global.open_scene(Global.main_scene.prev_scene)


func set_color(color : Color) -> void:
	PlayerInfo.player_data.player_customization.chosen_color = color
	PlayerInfo.save_data()

func set_face(face : String) -> void:
	PlayerInfo.player_data.player_customization.chosen_face = face
	PlayerInfo.save_data()

func set_marking(marking : String) -> void:
	PlayerInfo.player_data.player_customization.chosen_marking = marking
	PlayerInfo.save_data()
