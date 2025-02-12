extends Node

@export var master : Node

@export_category("Part")
@export var part_name : LineEdit
@export var part_pos : RichTextLabel
@export var part_size : RichTextLabel
@export var part_rot : RichTextLabel

@export var texture_container : HBoxContainer

@export var dynamic_containers : Array[HBoxContainer]
@export var dynamic_movement : CheckBox
@export var dynamic_rotation : CheckBox

@export var pivot_container : HBoxContainer

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
				master.create_rotation_tab(n)
			if n is moveable_component:
				pass
		
		if part is pivot:
			pivot_container.visible = true
		else:
			pivot_container.visible = false
		
	else:
		for n in dynamic_containers:
			n.visible = false
