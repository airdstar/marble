extends Control

@export var property_options : TabBar
@export var part_properties : VBoxContainer
@export var shape_properties : VBoxContainer
@export var rotation_properties : VBoxContainer

@export_category("Part")
@export var part_name : LineEdit
@export var part_pos : RichTextLabel
@export var part_size : RichTextLabel
@export var part_rot : RichTextLabel

@export var dynamic_movement : CheckBox
@export var dynamic_rotation : CheckBox

signal group_changed

func _ready() -> void:
	pass

func property_group_changed(index: int) -> void:
	part_properties.visible = false
	shape_properties.visible = false
	rotation_properties.visible = false
	if index == -1:
		visible = false
	else:
		visible = true
		match property_options.get_tab_title(index):
			"Part":
				part_properties.visible = true
			"Shape":
				shape_properties.visible = true
			"Rotation":
				rotation_properties.visible = true
		group_changed.emit(property_options.get_tab_title(index))

func pos_changed(new_pos : Vector3) -> void:
	match property_options.get_tab_title(property_options.current_tab):
		"Part":
			part_properties.part_pos.text = " Position: %.2f" % new_pos.x + ", %.2f" % new_pos.y + ", %.2f" % new_pos.z
		"Shape":
			shape_properties.shape_pos.text = " Position: %.2f" % new_pos.x + ", %.2f" % new_pos.y + ", %.2f" % new_pos.z

func size_changed(new_size : Vector3) -> void:
	match property_options.get_tab_title(property_options.current_tab):
		"Part":
			part_properties.part_size.text = " Size: %.2f" % new_size.x + ", %.2f" % new_size.y + ", %.2f" % new_size.z
		"Shape":
			shape_properties.shape_size.text = " Size: %.2f" % new_size.x + ", %.2f" % new_size.y + ", %.2f" % new_size.z

func rot_changed(new_rot : Vector3) -> void:
	match property_options.get_tab_title(property_options.current_tab):
		"Part":
			part_properties.part_rot.text = " Rotation: %d" % new_rot.x + ", %d" % new_rot.y + ", %d" % new_rot.z
		"Shape":
			shape_properties.shape_rot.text = " Rotation: %d" % new_rot.x + ", %d" % new_rot.y + ", %d" % new_rot.z

func part_selected(part : Node3D) -> void:
	var select_tab : int = get_tab("Part")
	if select_tab == -1:
		select_tab = property_options.tab_count
		property_options.add_tab("Part")
	
	property_options.current_tab = select_tab
	
	for n in part.get_children():
		pass
	
	property_group_changed(select_tab)
	part_properties.display_part_properties(part)

func part_unselected() -> void:
	if get_tab("Part") != -1:
		property_options.remove_tab(get_tab("Part"))
	
	if get_tab("Rotation") != -1:
		property_options.remove_tab(get_tab("Rotation"))
	
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
	shape_properties.display_shape_properties(shape)

func shape_unselected() -> void:
	if get_tab("Shape") != -1:
		property_options.remove_tab(get_tab("Shape"))
	
	if property_options.tab_count > 0:
		property_options.current_tab = 0
	else:
		property_options.current_tab = -1

func get_tab(tab_name : String) -> int:
	for n in property_options.tab_count:
		if property_options.get_tab_title(n) == tab_name:
			return n
	return -1

func create_rotation_tab(comp : rotateable_component) -> void:
	if get_tab("Rotation") == -1:
		property_options.add_tab("Rotation")
	rotation_properties.set_values(comp)
