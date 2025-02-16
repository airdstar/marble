extends Node

var colors : Array[Color] = [
	Color(0.9,0,0.1),
	Color(0,0.9,0.4),
	Color(0.1,0,0.9),
	Color(0.9,0.7,0),
	Color(0.6,0,0.9),
	Color(0.9,0.3,0)
]

var faces : Array[Texture2D]
var flairs : Array[Texture2D]


var face_path : String = "res://Assets/Customization/Faces/"
var flair_path : String = "res://Assets/Customization/Flairs/"

func _ready() -> void:
	var dir = DirAccess.open(face_path)
	dir.list_dir_begin()
	var current_face : String = dir.get_next()
	while current_face != "":
		if '.remap' in current_face:
			current_face = current_face.trim_suffix('.remap')
		
		if '.import' in current_face:
			current_face = dir.get_next()
			continue
		
		var holder = ResourceLoader.load(Cosmetic.face_path + current_face)
		faces.append(holder)
		current_face = dir.get_next()
	dir.list_dir_end()
	
	dir = DirAccess.open(flair_path)
	dir.list_dir_begin()
	var current_flair : String = dir.get_next()
	while current_flair != "":
		if '.remap' in current_flair:
			current_flair = current_flair.trim_suffix('.remap')
		
		if '.import' in current_flair:
			current_flair = dir.get_next()
			continue
		
		var holder = ResourceLoader.load(Cosmetic.flair_path + current_flair)
		flairs.append(holder)
		current_flair = dir.get_next()
	dir.list_dir_end()
		

func get_shades(color : Color) -> Array[Color]:
	var to_return : Array[Color]
	to_return.append(color.lightened(0.5))
	to_return.append(color.lightened(0.25))
	to_return.append(color)
	to_return.append(color.darkened(0.25))
	to_return.append(color.darkened(0.5))
	return to_return

func generate_random() -> PlayerCustomization:
	var to_return = PlayerCustomization.new()
	
	to_return.chosen_color = get_shades(colors.pick_random()).pick_random()
	to_return.chosen_face = faces.pick_random()
	to_return.chosen_flair = flairs.pick_random()
	
	return to_return
