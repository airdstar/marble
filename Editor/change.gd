extends Node

func position(new_pos : Vector3) -> void:
	if %Info.adjusting == %Info.adjustable.PART:
		%Info.selected_part.position = new_pos
	else:
		%Shape.offset_changed(new_pos)
	%Properties.update_pos_info()

func rotation(new_rot : Vector3) -> void:
	if %Info.adjusting == %Info.adjustable.PART:
		%Info.selected_part.rotation = new_rot
	else:
		%Shape.rotation_changed(new_rot)
	%Properties.update_rotation_info()

func scale(new_scale : Vector3) -> void:
	if %Info.adjusting == %Info.adjustable.PART:
		%Info.selected_part.scale = new_scale
	else:
		%Shape.size_changed(new_scale)
	%Properties.update_scale_info()
