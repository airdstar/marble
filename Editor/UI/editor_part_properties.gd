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

signal remove_extra_tabs
signal create_rotation_tab
signal get_all_non_pivot_parts

func display_part_properties(_part : part) -> void:
	part_name.text = _part.part_name
	
	part_pos.text = " Position: %.2f" % _part.position.x + ", %.2f" % _part.position.y + ", %.2f" % _part.position.z
	part_size.text = " Size: %.2f" % _part.scale.x + ", %.2f" % _part.scale.y + ", %.2f" % _part.scale.z
	part_rot.text = " Rotation: %d" % _part.rotation.x + ", %d" % _part.rotation.y + ", %d" % _part.rotation.z
	
	if _part is geometry:
		texture_container.visible = true
	else:
		texture_container.visible = false
	
	remove_extra_tabs.emit()
	
	if !_part.is_start:
		for n in dynamic_containers:
			n.visible = true
		dynamic_rotation.set_pressed_no_signal(false)
		
		for n in _part.get_children():
			if n is rotateable_component:
				dynamic_rotation.set_pressed_no_signal(true)
				create_rotation_tab.emit(n)
			if n is moveable_component:
				pass
		
	else:
		for n in dynamic_containers:
			n.visible = false
	
	if _part.is_pivot:
		pivot_container.visible = true
		for m in pivot_container.get_children():
			if m is not RichTextLabel:
				m.queue_free()
		get_all_non_pivot_parts.emit()
	else:
		pivot_container.visible = false

func display_non_pivots(parts : Array[Node]) -> void:
	for n in parts:
		var option_container = HBoxContainer.new()
		pivot_container.add_child(option_container)
		var label = RichTextLabel.new()
		label.text = n.part_name
		label.fit_content = true
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var check = CheckBox.new()
		
		if n.get_parent() == selection.selected_part:
			check.set_pressed_no_signal(true)
		
		option_container.add_child(label)
		option_container.add_child(check)
		
		check.toggled.connect(pivot_changed.bind(selection.selected_part, n))

func pivot_changed(toggled_on : bool, point : part, _part : Node) -> void:
	if toggled_on:
		_part.reparent(point)
	else:
		_part.reparent(selection.master.level_base)
