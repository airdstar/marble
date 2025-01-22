extends Resource
class_name Customization

var player_color : Dictionary = {
	"Red" : Color(0.9, 0, 0),
	"Green" : Color(0, 0.9, 0),
	"Blue" : Color(0, 0, 0.9)
}

@export var locked_colors : Array[String]

@export var chosen_color : String

func unlock_color(color : String) -> void:
	if locked_colors.has(color):
		pass
