extends Node

@export var master : Node
@export var selection : Node
@export var shape_handler : Node
@export var UI : Control

signal pos_changed
signal size_changed
signal rot_changed

func part_rotation_toggled(toggled_on: bool) -> void:
	if selection.selected_part != null:
		if toggled_on:
			var rot = preload("res://Editor/Parts/Components/RotateableComponent.tscn").instantiate()
			selection.selected_part.add_child(rot)
			rot.to_rotate = selection.selected_part
			rot.set_owner(master.level_base)
			if UI.properties.get_tab("Rotation") == -1:
				UI.properties.property_options.add_tab("Rotation")
			UI.properties.rotation_properties.set_values(rot)
		else:
			for n in selection.selected_part.get_children():
				if n is rotateable_component:
					n.queue_free()
					if UI.properties.get_tab("Rotation") != -1:
						UI.properties.property_options.remove_tab(UI.properties.get_tab("Rotation"))


func part_name_changed(new_text: String) -> void:
	selection.selected_part.set_meta("part_name", new_text)
	UI.sections.get_selected_part().text = new_text

func movement_detected(pos_change : Vector3) -> void:
	match master.adjusting:
		editor.adjustable.PART:
			selection.selected_part.position = pos_change
			pos_changed.emit(pos_change)
		editor.adjustable.SHAPE:
			shape_handler.offset_changed(pos_change)

func resize_detected(size_change : Vector3) -> void:
	match master.adjusting:
		editor.adjustable.PART:
			if selection.selected_part is not ProcMesh:
				selection.selected_part.scale = size_change
				size_changed.emit(size_change)
		editor.adjustable.SHAPE:
			shape_handler.size_changed(size_change)

func rotation_detected(rotation_change : Vector3) -> void:
	match master.adjusting:
		editor.adjustable.PART:
			if selection.selected_part is not ProcMesh:
				selection.selected_part.rotate_x(deg_to_rad(rotation_change.x))
				selection.selected_part.rotate_y(deg_to_rad(rotation_change.y))
				selection.selected_part.rotate_z(deg_to_rad(rotation_change.z))
				var part_rotation = Vector3(rad_to_deg(selection.selected_part.rotation.x), rad_to_deg(selection.selected_part.rotation.y), rad_to_deg(selection.selected_part.rotation.z))
				rot_changed.emit(part_rotation)
		editor.adjustable.SHAPE:
			shape_handler.rotation_changed(rotation_change)

func reset_rotation() -> void:
	match master.adjusting:
		editor.adjustable.PART:
			selection.selected_part.rotation = Vector3.ZERO
		editor.adjustable.SHAPE:
			selection.shape_preview.shape_info[0].rotation = Quaternion.IDENTITY
			selection.shape_preview.regenerate_mesh()
	rot_changed.emit(Vector3.ZERO)

func dynamic_rot_amount_changed(value : float) -> void:
	selection.selected_component.rotation_amount = value
	UI.properties.rotation_properties.rotation_amount.text = " Rotation Deg: %d" % value

func dynamic_rot_speed_changed(value : float) -> void:
	selection.selected_component.rotation_speed = value
	UI.properties.rotation_properties.rotation_speed.text = " Secs per rotation: %.1f" % value
