extends shape_resource
class_name sphere

@export_range(3,32) var subdivisions := 4

func get_surface_array(index : int) -> Array:
	var cube_info := cube.new()
	cube_info.subdivisions = subdivisions
	var surface_array := cube_info.get_surface_array(index)
	for n : int in surface_array[Mesh.ARRAY_VERTEX].size():
		var vertex : Vector3 = surface_array[Mesh.ARRAY_VERTEX][n]
		surface_array[Mesh.ARRAY_VERTEX][n] = vertex.normalized() / 2.0
		surface_array[Mesh.ARRAY_NORMAL][n] = vertex.normalized()
	
	
	surface_array[Mesh.ARRAY_VERTEX] = apply_size(surface_array[Mesh.ARRAY_VERTEX])
	surface_array[Mesh.ARRAY_VERTEX] = apply_offset(surface_array[Mesh.ARRAY_VERTEX])
	
	
	return surface_array
