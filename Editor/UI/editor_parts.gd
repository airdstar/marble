extends Control

var shapes : Dictionary = {
	"Plane" : plane,
	"Cube" : cube,
	"Polygon" : polygon,
	"Sphere" : sphere
}

var important_parts : Dictionary = {
	"Start" : "res://Editor/Parts/Important/SpawnZone.tscn",
	"Goal" : "res://Editor/Parts/Important/EndZone.tscn",
	"False Goal" : "res://Editor/Parts/Important/FalseEndZone.tscn"
}

@export var shape_holder : GridContainer
@export var important_holder : VBoxContainer

signal new_part_selected
signal new_shape_selected

func _ready() -> void:
	tab_changed(0)
	for n : String in shapes:
		var current_button : Button = Button.new()
		current_button.custom_minimum_size = Vector2(size.x / 4, size.x / 4 )
		current_button.text = n
		shape_holder.add_child(current_button)
		current_button.pressed.connect(shape_selected.bind(shapes[n]))
	
	for n : String in important_parts:
		var current_button : Button = Button.new()
		current_button.custom_minimum_size = Vector2(32,32)
		current_button.text = n
		important_holder.add_child(current_button)
		current_button.pressed.connect(part_selected.bind(important_parts[n]))

func part_selected(part_path : String) -> void:
	var holder = load(part_path)
	holder = holder.instantiate()
	new_part_selected.emit(holder)

func shape_selected(shape : Resource) -> void:
	new_shape_selected.emit(shape.new())

func tab_changed(tab: int) -> void:
	shape_holder.visible = false
	important_holder.visible = false
	match tab:
		0:
			shape_holder.visible = true
		1:
			important_holder.visible = true
