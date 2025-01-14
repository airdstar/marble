extends Control

var shapes : Dictionary = {
	"Plane" : plane,
	"Cube" : cube,
	"Polygon" : polygon,
	"Cone" : cone,
	"Torus" : torus
}

var shape_buttons : Array[Button] = []

@onready var option_holder : VBoxContainer = $VBoxContainer/ScrollContainer/VBoxContainer

signal new_part_selected
signal new_shape_selected

func _ready() -> void:
	for n : String in shapes:
		var current_button : Button = Button.new()
		current_button.text = n
		shape_buttons.append(current_button)
		option_holder.add_child(current_button)
		current_button.pressed.connect(shape_selected.bind(shapes[n]))

func show_shapes() -> void:
	for n : Button in shape_buttons:
		n.visible = true

func hide_shapes() -> void:
	for n : Button in shape_buttons:
		n.visible = false

func shape_selected(shape : Resource) -> void:
	new_shape_selected.emit(shape.new())
