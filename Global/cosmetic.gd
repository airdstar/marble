extends Node

var colors : Array[Color] = [
	Color(0.9, 0.2, 0.339, 1.0),
	Color(0.0, 0.769, 0.4, 1.0),
	Color(0.1, 0.49, 0.9, 1.0),
	Color(0.9, 0.827, 0.0, 1.0),
	Color(0.6, 0.232, 0.704, 1.0),
	Color(0.9, 0.3, 0.307, 1.0)
]

var decals : Array[Texture2D]
var path : String = "res://Assets/Customization/"


func _ready() -> void:
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	var current : String = dir.get_next()
	while current != "":
		if '.remap' in current:
			current = current.trim_suffix('.remap')
		
		if '.import' in current:
			current = dir.get_next()
			continue
		
		var holder = ResourceLoader.load(path + current)
		decals.append(holder)
		current = dir.get_next()
	dir.list_dir_end()

func generate_random() -> PlayerCustomization:
	var to_return = PlayerCustomization.new()
	
	to_return.chosen_color = colors.pick_random()
	to_return.chosen_decal = decals.pick_random()
	
	return to_return
