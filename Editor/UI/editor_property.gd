extends Control

@onready var property_options := $VBoxContainer/OptionButton

@onready var part_properties := $VBoxContainer/ScrollContainer/VBoxContainer/PartProperties
@onready var shape_properties := $VBoxContainer/ScrollContainer/VBoxContainer/ShapeProperties


@onready var part_pos := $VBoxContainer/ScrollContainer/VBoxContainer/PartProperties/PartPos
@onready var part_size


@onready var shape_name := $VBoxContainer/ScrollContainer/VBoxContainer/ShapeProperties/ShapeName
@onready var shape_pos := $VBoxContainer/ScrollContainer/VBoxContainer/ShapeProperties/ShapePos
@onready var shape_size

@onready var shape_sides_holder := $VBoxContainer/ScrollContainer/VBoxContainer/ShapeProperties/ShapeSides
@onready var shape_sides := $VBoxContainer/ScrollContainer/VBoxContainer/ShapeProperties/ShapeSides/Sides

@onready var shape_orientation_holder := $VBoxContainer/ScrollContainer/VBoxContainer/ShapeProperties/ShapeOrientation
@onready var shape_orientation := $VBoxContainer/ScrollContainer/VBoxContainer/ShapeProperties/ShapeOrientation/ShapeOrientation

@onready var shape_flip_orientation_holder := $VBoxContainer/ScrollContainer/VBoxContainer/ShapeProperties/ShapeFlipOrientation
@onready var shape_flip_orientation := $VBoxContainer/ScrollContainer/VBoxContainer/ShapeProperties/ShapeFlipOrientation/ShapeFlipOrientation

@onready var shape_pointed_holder
@onready var shape_pointed
@onready var shape_pointed_direction

@onready var shape_hole_holder
@onready var shape_hole
@onready var shape_hole_size

signal shape_name_changed
signal group_changed

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
	group_changed.emit(index)

func part_selected(part : Node3D) -> void:
	property_options.selected = 0
	property_group_changed(0)

func pos_changed(new_pos : Vector3) -> void:
	match property_options.selected:
		0:
			part_pos.text = " Position: %.1f" % new_pos.x + ", %.1f" % new_pos.y + ", %.1f" % new_pos.z
		1:
			shape_pos.text = " Position: %.1f" % new_pos.x + ", %.1f" % new_pos.y + ", %.1f" % new_pos.z

func shape_selected(shape : shape_resource) -> void:
	property_options.set_item_disabled(1, false)
	property_options.selected = 1
	property_group_changed(1)
	display_shape_properties(shape)

func shape_name_submitted(new_text: String) -> void:
	if new_text != "":
		shape_name_changed.emit(new_text)


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
