extends Control

var shapes : Dictionary = {
	"Plane" : plane,
	"Cube" : cube,
	"Polygon" : polygon,
	"Sphere" : sphere
}

var important_parts : Dictionary = {
	"Pivot" : "res://Editor/Parts/Important/Pivot.tscn",
	"Start" : "res://Editor/Parts/Important/SpawnZone.tscn",
	"Goal" : "res://Editor/Parts/Important/Goal.tscn"
}

var misc_parts : Dictionary = {
	"Boost Pad" : "res://Editor/Parts/Misc/BoostPad.tscn",
	"Launch Pad" : "res://Editor/Parts/Misc/LaunchPad.tscn",
	"Boost Zone" : "res://Editor/Parts/Misc/BoostZone.tscn"
}

@export var shape_holder : GridContainer
@export var parts_holder : VBoxContainer

@export var important_holder : GridContainer
@export var misc_holder : GridContainer

signal new_part_selected
signal new_shape_selected

func _ready() -> void:
	tab_changed(0)
	for n : String in shapes:
		var current_button : Button = create_button()
		current_button.text = n
		shape_holder.add_child(current_button)
		current_button.pressed.connect(shape_selected.bind(shapes[n]))
	
	for n : String in important_parts:
		var current_button : Button = create_button()
		current_button.text = n
		important_holder.add_child(current_button)
		current_button.pressed.connect(part_selected.bind(important_parts[n]))
	
	for n : String in misc_parts:
		var current_button : Button = create_button()
		current_button.text = n
		misc_holder.add_child(current_button)
		current_button.pressed.connect(part_selected.bind(misc_parts[n]))
	
func create_button() -> Button:
	var to_return = Button.new()
	to_return.custom_minimum_size = Vector2(size.x / 4, size.x / 4)
	return to_return

func part_selected(part_path : String) -> void:
	var holder = load(part_path)
	holder = holder.instantiate()
	new_part_selected.emit(holder)

func shape_selected(shape : Resource) -> void:
	new_shape_selected.emit(shape.new())

func tab_changed(tab: int) -> void:
	shape_holder.visible = false
	parts_holder.visible = false
	match tab:
		0:
			shape_holder.visible = true
		1:
			parts_holder.visible = true
			
