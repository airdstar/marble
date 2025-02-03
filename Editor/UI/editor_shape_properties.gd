extends Node

@export var shape_name : LineEdit
@export var shape_pos : RichTextLabel
@export var shape_size : RichTextLabel
@export var shape_rot : RichTextLabel

@export var shape_modifier_holder : HBoxContainer
@export var shape_modifier : OptionButton

@export_category("Exclusive")

@export var shape_sides_holder : HBoxContainer
@export var shape_sides : SpinBox

@export var shape_orientation_holder : HBoxContainer
@export var shape_orientation : OptionButton

@export var shape_flip_orientation_holder : HBoxContainer
@export var shape_flip_orientation : CheckButton

@export_category("Hole Modifier")
@export var shape_hole_holder : VBoxContainer
@export var shape_hole_offset_x : SpinBox
@export var shape_hole_offset_y : SpinBox
@export var shape_hole_offset_z : SpinBox

@export var shape_hole_size : SpinBox

signal _hole_offset_changed
signal _hole_size_changed

func display_shape_properties(shape : shape_resource) -> void:
	shape.set_mods()
	shape_name.text = shape.shape_name
	shape_pos.text = " Position: %.2f" % shape.total_offset.x + ", %.2f" % shape.total_offset.y + ", %.2f" % shape.total_offset.z
	shape_size.text = " Size: %.2f" % shape.size.x + ", %.2f" % shape.size.y + ", %.2f" % shape.size.z
	var e = shape.rotation.get_euler()
	shape_rot.text = " Rotation: %d" % rad_to_deg(e.x) + ", %d" % rad_to_deg(e.y) + ", %d" % rad_to_deg(e.z)
	
	if shape.usable_mods.size() > 1:
		shape_modifier_holder.visible = true
		shape_modifier.clear()
		shape_modifier.add_item("None")
		for n in shape.usable_mods:
			if n != "None":
				shape_modifier.add_item(n)
			if shape.modifier == shape.usable_mods[n]:
				shape_modifier.selected = shape_modifier.item_count - 1
				if n == "Hole":
					shape_hole_holder.visible = true
				
	else:
		shape_modifier_holder.visible = false
		shape_hole_holder.visible = false
	
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
	
	if "hole_offset" in shape:
		shape_hole_offset_x.set_value_no_signal(shape.hole_offset.x)
		shape_hole_offset_y.set_value_no_signal(shape.hole_offset.y)
		shape_hole_offset_z.set_value_no_signal(shape.hole_offset.z)
	
	if "hole_size" in shape:
		shape_hole_size.set_value_no_signal(shape.hole_size)

func mod_changed(index : int) -> void:
	shape_hole_holder.visible = false
	match shape_modifier.get_item_text(index):
		"Hole":
			shape_hole_holder.visible = true

func hole_offset_changed(_value : float) -> void:
	_hole_offset_changed.emit(Vector3(shape_hole_offset_x.value, shape_hole_offset_y.value, shape_hole_offset_z.value))

func hole_size_changed(_value : float) -> void:
	_hole_size_changed.emit(shape_hole_size.value)
