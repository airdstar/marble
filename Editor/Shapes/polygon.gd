extends shape_resource
class_name polygon

@export_range(5, 32) var sides := 5

func get_surface_array(index : int) -> Array:
	var surface_array : Array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	
	var positions := PackedVector3Array()
	var normals := PackedVector3Array()
	var indices := PackedInt32Array()
	
	var index_offset := index
	
	for n : float in sides:
		positions.append_array([
			Vector3(0, size.y / 2, 0) + total_offset,
			Vector3(cos(n/sides * PI * 2.0) * (size.x / 2), size.y / 2, sin(n/sides * PI * 2.0) * (size.z / 2)) + total_offset,
			Vector3(cos((n + 1)/sides * PI * 2.0) * (size.x / 2), size.y / 2, sin((n + 1)/sides * PI * 2.0) * (size.z / 2)) + total_offset 
		])
		normals.append_array([
				Vector3.UP,
				Vector3.UP,
				Vector3.UP
			])
		indices.append_array([index_offset + 3 * n,
								index_offset + 1 + 3 * n,
								index_offset + 2 + 3 * n])
	
	index_offset += sides * 3
	
	for n : float in sides:
		positions.append_array([
			Vector3(0, -size.y / 2, 0) + total_offset,
			Vector3(cos(n/sides * PI * 2.0) * (size.x / 2), -size.y / 2, sin(n/sides * PI * 2.0) * (size.z / 2)) + total_offset,
			Vector3(cos((n + 1)/sides * PI * 2.0) * (size.x / 2), -size.y / 2, sin((n + 1)/sides * PI * 2.0) * (size.z / 2)) + total_offset 
		])
		normals.append_array([
				Vector3.DOWN,
				Vector3.DOWN,
				Vector3.DOWN
			])
		indices.append_array([index_offset + 2 + 3 * n,
								index_offset + 1 + 3 * n,
								index_offset + 3 * n])
	
	index_offset += sides * 3 
	
	for n : float in sides:
		positions.append_array([
			Vector3(cos(n/sides * PI * 2.0) * (size.x / 2), size.y / 2, sin(n/sides * PI * 2.0) * (size.z / 2)) + total_offset,
			Vector3(cos((n + 1)/sides * PI * 2.0) * (size.x / 2), size.y / 2, sin((n + 1)/sides * PI * 2.0) * (size.z / 2)) + total_offset,
			Vector3(cos(n/sides * PI * 2.0) * (size.x / 2), -size.y / 2, sin(n/sides * PI * 2.0) * (size.z / 2)) + total_offset,
			Vector3(cos((n + 1)/sides * PI * 2.0) * (size.x / 2), -size.y / 2, sin((n + 1)/sides * PI * 2.0) * (size.z / 2)) + total_offset 
		])
		normals.append_array([
				Vector3.BACK,
				Vector3.BACK,
				Vector3.BACK,
				Vector3.BACK
			])
		indices.append_array([index_offset + 4 * n,
								index_offset + 2 + 4 * n,
								index_offset + 1 + 4 * n,
								index_offset + 1 + 4 * n,
								index_offset + 2 + 4 * n,
								index_offset + 3 + 4 * n])
	surface_array[Mesh.ARRAY_VERTEX] = positions
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices
	return surface_array