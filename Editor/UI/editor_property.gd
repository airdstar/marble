extends Control

@onready var property_options := $VBoxContainer/OptionButton

@onready var part_properties := $VBoxContainer/ScrollContainer/VBoxContainer/PartProperties
@onready var shape_properties := $VBoxContainer/ScrollContainer/VBoxContainer/ShapeProperties

@onready var shape_name := $VBoxContainer/ScrollContainer/VBoxContainer/ShapeProperties/ShapeName
@onready var shape_pos := $VBoxContainer/ScrollContainer/VBoxContainer/ShapeProperties/ShapePos
@onready var shape_sides_holder := $VBoxContainer/ScrollContainer/VBoxContainer/ShapeProperties/ShapeSides
@onready var shape_sides := $VBoxContainer/ScrollContainer/VBoxContainer/ShapeProperties/ShapeSides/Sides
@onready var shape_orientation_holder := $VBoxContainer/ScrollContainer/VBoxContainer/ShapeProperties/ShapeOrientation
@onready var shape_orientation := $VBoxContainer/ScrollContainer/VBoxContainer/ShapeProperties/ShapeOrientation/ShapeOrientation
@onready var shape_flip_orientation_holder := $VBoxContainer/ScrollContainer/VBoxContainer/ShapeProperties/ShapeFlipOrientation
@onready var shape_flip_orientation := $VBoxContainer/ScrollContainer/VBoxContainer/ShapeProperties/ShapeFlipOrientation/ShapeFlipOrientation

signal shape_name_changed

func _ready() -> void:
	property_options.set_item_disabled(1, true)

func property_group_changed(index: int) -> void:
	part_properties.visible = false
	shape_properties.visible = false
	match index:
		0:
			part_properties.visible = true
		1:
			shape_properties.visible = true


func shape_name_submitted(new_text: String) -> void:
	if new_text != "":
		shape_name_changed.emit(new_text)

func shape_pos_changed(new_pos : Vector3) -> void:
	shape_pos.text = "Position: %.1f" % new_pos.x + ", %.1f" % new_pos.y + ", %.1f" % new_pos.z

func part_selected(part : Node3D) -> void:
	if part is ProcMesh:
		property_options.set_deferred("selected", 0)


func shape_selected(shape : shape_resource) -> void:
	property_options.set_item_disabled(1, false)
	display_shape_properties(shape)

func shape_unselected() -> void:
	property_options.set_item_disabled(1, true)

func display_shape_properties(shape : shape_resource) -> void:
	shape_name.text = shape.shape_name
	shape_pos.text = " Position: %.1f" % shape.total_offset.x + ", %.1f" % shape.total_offset.y + ", %.1f" % shape.total_offset.z
	
	if "sides" in shape:
		shape_sides_holder.visible = true
		shape_sides.value = shape.sides
	else:
		shape_sides_holder.visible = false
	
	if "orientation" in shape:
		shape_orientation_holder.visible = true
		shape_orientation.selected = shape.orientation
	else:
		shape_orientation_holder.visible = false
	
	if "flip_orientation" in shape:
		shape_flip_orientation_holder.visible = true
		shape_flip_orientation.button_pressed = shape.flip_orientation
	else:
		shape_flip_orientation_holder.visible = false
