extends Control

@export var property_options : TabBar
@export var part_properties : VBoxContainer
@export var shape_properties : VBoxContainer

@export_category("Part")
@export var part_name : LineEdit
@export var part_pos : RichTextLabel
@export var part_size : RichTextLabel
@export var part_rot : RichTextLabel

@export var dynamic_movement : CheckBox
@export var dynamic_rotation : CheckBox

@export_category("Movement")
@export var mov_has_trigger : CheckBox
@export var mov_pos : RichTextLabel

@export_category("Rotation")
@export var rot_has_trigger : CheckBox
@export var rot_amount : RichTextLabel

@export_category("Shape")

@onready var shape_name := $VBoxContainer/ScrollContainer/VBoxContainer/ShapeProperties/ShapeName
@onready var shape_pos := $VBoxContainer/ScrollContainer/VBoxContainer/ShapeProperties/ShapePos
@onready var shape_size := $VBoxContainer/ScrollContainer/VBoxContainer/ShapeProperties/ShapeSize
@export var shape_rot : RichTextLabel

@onready var shape_sides_holder := $VBoxContainer/ScrollContainer/VBoxContainer/ShapeProperties/ShapeSides
@onready var shape_sides := $VBoxContainer/ScrollContainer/VBoxContainer/ShapeProperties/ShapeSides/Sides

@onready var shape_orientation_holder := $VBoxContainer/ScrollContainer/VBoxContainer/ShapeProperties/ShapeOrientation
@onready var shape_orientation := $VBoxContainer/ScrollContainer/VBoxContainer/ShapeProperties/ShapeOrientation/ShapeOrientation

@onready var shape_flip_orientation_holder := $VBoxContainer/ScrollContainer/VBoxContainer/ShapeProperties/ShapeFlipOrientation
@onready var shape_flip_orientation := $VBoxContainer/ScrollContainer/VBoxContainer/ShapeProperties/ShapeFlipOrientation/ShapeFlipOrientation

@onready var shape_modifier_holder := $VBoxContainer/ScrollContainer/VBoxContainer/ShapeProperties/ShapeModifier
@onready var shape_modifier := $VBoxContainer/ScrollContainer/VBoxContainer/ShapeProperties/ShapeModifier/Modifier


signal shape_name_changed
signal rotation_change
signal group_changed

func _ready() -> void:
	pass

func property_group_changed(index: int) -> void:
	part_properties.visible = false
	shape_properties.visible = false
	if index == -1:
		visible = false
	else:
		visible = true
		match property_options.get_tab_title(index):
			"Part":
				part_properties.visible = true
			"Shape":
				shape_properties.visible = true
		group_changed.emit(property_options.get_tab_title(index))

func pos_changed(new_pos : Vector3) -> void:
	match property_options.get_tab_title(property_options.current_tab):
		"Part":
			part_pos.text = " Position: %.1f" % new_pos.x + ", %.1f" % new_pos.y + ", %.1f" % new_pos.z
		"Shape":
			shape_pos.text = " Position: %.1f" % new_pos.x + ", %.1f" % new_pos.y + ", %.1f" % new_pos.z

func size_changed(new_size : Vector3) -> void:
	match property_options.get_tab_title(property_options.current_tab):
		"Part":
			part_size.text = " Size: %.1f" % new_size.x + ", %.1f" % new_size.y + ", %.1f" % new_size.z
		"Shape":
			shape_size.text = " Size: %.1f" % new_size.x + ", %.1f" % new_size.y + ", %.1f" % new_size.z

func rot_changed(new_rot : Vector3) -> void:
	match property_options.get_tab_title(property_options.current_tab):
		"Part":
			part_rot.text = " Rotation: %d" % new_rot.x + ", %d" % new_rot.y + ", %d" % new_rot.z
		"Shape":
			shape_rot.text = " Rotation: %d" % new_rot.x + ", %d" % new_rot.y + ", %d" % new_rot.z

func part_selected(part : Node3D) -> void:
	var select_tab : int = get_tab("Part")
	if select_tab == -1:
		select_tab = property_options.tab_count
		property_options.add_tab("Part")
	
	property_options.current_tab = select_tab
	part_name.text = part.get_meta("part_name")
	
	for n in part.get_children():
		pass
	
	property_group_changed(select_tab)

func part_unselected() -> void:
	if get_tab("Part") != -1:
		property_options.remove_tab(get_tab("Part"))
	
	if property_options.tab_count > 0:
		property_options.current_tab = 0
	else:
		property_options.current_tab = -1
	

func shape_selected(shape : shape_resource) -> void:
	var select_tab : int = get_tab("Shape")
	if select_tab == -1:
		select_tab = property_options.tab_count
		property_options.add_tab("Shape")
	
	property_options.current_tab = select_tab
	
	property_group_changed(select_tab)
	display_shape_properties(shape)

func shape_unselected() -> void:
	if get_tab("Shape") != -1:
		property_options.remove_tab(get_tab("Shape"))
	
	if property_options.tab_count > 0:
		property_options.current_tab = 0
	else:
		property_options.current_tab = -1

func shape_name_submitted(new_text: String) -> void:
	if new_text != "":
		shape_name_changed.emit(new_text)

func get_tab(tab_name : String) -> int:
	for n in property_options.tab_count:
		if property_options.get_tab_title(n) == tab_name:
			return n
	return -1

func display_shape_properties(shape : shape_resource) -> void:
	shape.set_mods()
	shape_name.text = shape.shape_name
	shape_pos.text = " Position: %.1f" % shape.total_offset.x + ", %.1f" % shape.total_offset.y + ", %.1f" % shape.total_offset.z
	shape_size.text = " Size: %.1f" % shape.size.x + ", %.1f" % shape.size.y + ", %.1f" % shape.size.z
	#shape_rot.text = " Rotation: %d" % shape.x_rotation + ", %d" % shape.y_rotation + ", %d" % shape.z_rotation
	
	if shape.usable_mods.size() > 1:
		shape_modifier_holder.visible = true
		shape_modifier.clear()
		shape_modifier.add_item("None")
		for n in shape.usable_mods:
			if n != "None":
				shape_modifier.add_item(n)
			if shape.modifier == shape.usable_mods[n]:
				shape_modifier.selected = shape_modifier.item_count - 1
	else:
		shape_modifier_holder.visible = false
	
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
