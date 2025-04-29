extends Node

var colors : Array[Color] = [
	Color(0.9,0,0.1),
	Color(0,0.9,0.4),
	Color(0.1,0,0.9),
	Color(0.9,0.7,0),
	Color(0.6,0,0.9),
	Color(0.9,0.3,0)
]

var cosmetics : Array[Texture2D]
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
		cosmetics.append(holder)
		current = dir.get_next()
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
	to_return.chosen_front = cosmetics.pick_random()
	to_return.chosen_back = cosmetics.pick_random()
	
	return to_return
