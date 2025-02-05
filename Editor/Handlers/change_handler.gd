extends Node

@export var master : Node
@export var selection : Node


func part_name_changed(new_text: String) -> void:
	if new_text != "":
		selection.selected_part.set_meta("part_name", new_text)
		master.sections.get_selected_part().text = new_text

func movement_detected(pos_change : Vector3) -> void:
	match adjusting:
		editor.adjustable.PART:
			selected_part.position = pos_change
			adjuster.selected_pos_changed(pos_change)
			UI.properties.pos_changed(pos_change)
		editor.adjustable.SHAPE:
			shape_handler.offset_changed(pos_change)

func resize_detected(size_change : Vector3) -> void:
	match adjusting:
		editor.adjustable.PART:
			if selected_part is not ProcMesh:
				selected_part.scale = size_change
				UI.properties.size_changed(size_change)
				adjuster.selected_size_changed(size_change)
		editor.adjustable.SHAPE:
			shape_handler.size_changed(size_change)

func rotation_detected(rotation_change : Vector3) -> void:
	match adjusting:
		editor.adjustable.PART:
			if selected_part is not ProcMesh:
				selected_part.rotate_x(deg_to_rad(rotation_change.x))
				selected_part.rotate_y(deg_to_rad(rotation_change.y))
				selected_part.rotate_z(deg_to_rad(rotation_change.z))
				var part_rotation = Vector3(rad_to_deg(selected_part.rotation.x), rad_to_deg(selected_part.rotation.y), rad_to_deg(selected_part.rotation.z))
				UI.properties.rot_changed(part_rotation)
				adjuster.selected_rotation_changed(part_rotation)
		editor.adjustable.SHAPE:
			shape_handler.rotation_changed(rotation_change)

func reset_movement() -> void:
	match adjusting:
		editor.adjustable.PART:
			selected_part.position = Vector3.ZERO
			adjuster.selected_pos_changed(Vector3.ZERO)
			UI.properties.pos_changed(Vector3.ZERO)
		editor.adjustable.SHAPE:
			shape_handler.offset_changed(Vector3.ZERO)

func reset_size() -> void:
	match adjusting:
		editor.adjustable.PART:
			selected_part.scale = Vector3(1,1,1)
			UI.properties.size_changed(Vector3(1,1,1))
			adjuster.selected_size_changed(Vector3(1,1,1))
		editor.adjustable.SHAPE:
			shape_handler.size_changed(Vector3(1,1,1))

func reset_rotation() -> void:
	match adjusting:
		editor.adjustable.PART:
			selected_part.rotation = Vector3.ZERO
		editor.adjustable.SHAPE:
			shape_preview.shape_info[0].rotation = Quaternion.IDENTITY
			shape_preview.regenerate_mesh()
	UI.properties.rot_changed(Vector3.ZERO)
	adjuster.selected_rotation_changed(Vector3.ZERO)
