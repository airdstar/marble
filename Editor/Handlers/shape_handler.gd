extends Node

@export var master : ProcMesh

signal offset_change_successful
signal size_change_successful
signal rotation_change_successful


func offset_changed(pos_change : Vector3) -> void:
	if master.shape_info.size() != 0:
		master.shape_info[0].total_offset = pos_change
		master.regenerate_mesh()
		offset_change_successful.emit(pos_change)

func size_changed(new_size : Vector3) -> void:
	if master.shape_info.size() != 0:
		master.shape_info[0].size = new_size
		master.regenerate_mesh()
		size_change_successful.emit(new_size)

func rotation_changed(new_rotation : Vector3) -> void:
	if master.shape_info.size() != 0:
		var q1 : Quaternion = Quaternion(
			sin(deg_to_rad(new_rotation.x/2)) * cos(deg_to_rad(new_rotation.y/2)) * cos(deg_to_rad(new_rotation.z/2)) - cos(deg_to_rad(new_rotation.x/2)) * sin(deg_to_rad(new_rotation.y/2)) * sin(deg_to_rad(new_rotation.z/2)),
			cos(deg_to_rad(new_rotation.x/2)) * sin(deg_to_rad(new_rotation.y/2)) * cos(deg_to_rad(new_rotation.z/2)) + sin(deg_to_rad(new_rotation.x/2)) * cos(deg_to_rad(new_rotation.y/2)) * sin(deg_to_rad(new_rotation.z/2)),
			cos(deg_to_rad(new_rotation.x/2)) * cos(deg_to_rad(new_rotation.y/2)) * sin(deg_to_rad(new_rotation.z/2)) - sin(deg_to_rad(new_rotation.x/2)) * sin(deg_to_rad(new_rotation.y/2)) * cos(deg_to_rad(new_rotation.z/2)),
			cos(deg_to_rad(new_rotation.x/2)) * cos(deg_to_rad(new_rotation.y/2)) * cos(deg_to_rad(new_rotation.z/2)) + sin(deg_to_rad(new_rotation.x/2)) * sin(deg_to_rad(new_rotation.y/2)) * sin(deg_to_rad(new_rotation.z/2))
		)
		master.shape_info[0].rotation = master.shape_info[0].rotation * q1
		master.regenerate_mesh()
		var e = master.shape_info[0].rotation.get_euler()
		rotation_change_successful.emit(Vector3(rad_to_deg(e.x), rad_to_deg(e.y), rad_to_deg(e.z)))

func hole_offset_changed(new_offset : Vector3) -> void:
	if master.shape_info.size() != 0:
		master.shape_info[0].hole_offset = new_offset
		master.regenerate_mesh()

func hole_size_changed(new_size : float) -> void:
	if master.shape_info.size() != 0:
		master.shape_info[0].hole_size = new_size
		master.regenerate_mesh()

func name_changed(new_name : String) -> void:
	if master.shape_info.size() != 0:
		master.shape_info[0].shape_name = new_name

func sides_changed(value: float) -> void:
	master.shape_info[0].sides = value
	master.regenerate_mesh()

func orientation_changed(index : int) -> void:
	master.shape_info[0].orientation = index
	master.regenerate_mesh()

func flip_orientation_changed(toggled_on: bool) -> void:
	master.shape_info[0].flip_orientation = toggled_on
	master.regenerate_mesh()

func modifier_changed(index: int) -> void:
	master.shape_info[0].modifier = index
	master.regenerate_mesh()
