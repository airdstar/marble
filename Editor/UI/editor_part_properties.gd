extends Node

@export var selection : Node

@export_category("Part")
@export var part_name : LineEdit
@export var part_pos : RichTextLabel
@export var part_size : RichTextLabel
@export var part_rot : RichTextLabel

@export var texture_container : HBoxContainer

@export var dynamic_containers : Array[HBoxContainer]
@export var dynamic_movement : CheckBox
@export var dynamic_rotation : CheckBox

@export var pivot_container : VBoxContainer

signal create_rotation_tab
signal get_all_non_pivot_parts

func display_part_properties(part : Node3D) -> void:
	part_name.text = part.get_meta("part_name")
	
	part_pos.text = " Position: %.2f" % part.position.x + ", %.2f" % part.position.y + ", %.2f" % part.position.z
	part_size.text = " Size: %.2f" % part.scale.x + ", %.2f" % part.scale.y + ", %.2f" % part.scale.z
	part_rot.text = " Rotation: %d" % part.rotation.x + ", %d" % part.rotation.y + ", %d" % part.rotation.z
	
	if part is ProcMesh:
		texture_container.visible = true
	else:
		texture_container.visible = false
	
	if part is not start:
		for n in dynamic_containers:
			n.visible = true
		dynamic_rotation.button_pressed = false
		
		for n in part.get_children():
			if n is rotateable_component:
				dynamic_rotation.button_pressed = true
				create_rotation_tab.emit(n)
			if n is moveable_component:
				pass
		
	else:
		for n in dynamic_containers:
			n.visible = false
	
	if part is pivot:
		pivot_container.visible = true
		for m in pivot_container.get_children():
			if m is not RichTextLabel:
				m.queue_free()
		get_all_non_pivot_parts.emit()
	else:
		pivot_container.visible = false

func display_non_pivots(parts : Array[Node3D]) -> void:
	for n in parts:
		var option_container = HBoxContainer.new()
		pivot_container.add_child(option_container)
		var label = RichTextLabel.new()
		label.text = n.get_meta("part_name")
		label.fit_content = true
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var check = CheckBox.new()
		
		if n.get_parent() == selection.selected_part:
			check.set_pressed_no_signal(true)
		
		option_container.add_child(label)
		option_container.add_child(check)
		
		check.toggled.connect(pivot_changed.bind(selection.selected_part, n))

func pivot_changed(toggled_on : bool, point : pivot, part : Node3D) -> void:
	if toggled_on:
		part.reparent(point)
	else:
		part.reparent(selection.master.level_base)
