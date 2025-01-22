extends shape_resource
class_name cube

@export_range(1,32) var subdivisions := 1

func get_surface_array(index : int) -> Array:
	var surface_array : Array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	
	var positions := PackedVector3Array()
	var normals := PackedVector3Array()
	var indices := PackedInt32Array()
	
	for n : int in 6:
		var ind_offset := 4 * n * subdivisions * subdivisions + index
		var plane_info := plane.new()
		plane_info.total_offset = total_offset
		@warning_ignore("integer_division")
		match n / 2:
			0:
				plane_info.orientation = 1
				plane_info.size = Vector3(size.x, 1, size.z)
				plane_info.center_offset = Vector3(0, 0.5 * size.y, 0)
			1:
				plane_info.orientation = 0
				plane_info.size = Vector3(1, size.y, size.z)
				plane_info.center_offset = Vector3(0.5 * size.x, 0, 0)
			2:
				plane_info.orientation = 2
				plane_info.size = Vector3(size.x, size.y, 1)
				plane_info.center_offset = Vector3(0, 0, 0.5 * size.z)
		if n % 2 == 1:
			plane_info.flip_orientation = true
			plane_info.center_offset = -plane_info.center_offset
		plane_info.subdivisions = subdivisions
		var plane_surface := plane_info.get_surface_array(ind_offset)
		
		positions.append_array(plane_surface[Mesh.ARRAY_VERTEX])
		normals.append_array(plane_surface[Mesh.ARRAY_NORMAL])
		indices.append_array(plane_surface[Mesh.ARRAY_INDEX])
	
	positions = apply_rotation(positions)
	
	surface_array[Mesh.ARRAY_VERTEX] = positions
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices
	
	return surface_array
