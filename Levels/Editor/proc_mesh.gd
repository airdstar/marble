extends MeshInstance3D

var shape_info : Array[shape_resource]
var array_mesh : ArrayMesh

var tri_count : int = 0

func clear_mesh() -> void:
	shape_info.clear()
	tri_count = 0
	regenerate_mesh()

func add_shape(new_shape : shape_resource) -> void:
	shape_info.append(new_shape)
	regenerate_mesh()

func regenerate_mesh() -> void:
	if !array_mesh:
		array_mesh = ArrayMesh.new()
		mesh = array_mesh
	array_mesh.clear_surfaces()
	var surface_array : Array = []
	var index_offset : int = 0
	if shape_info.size() != 0:
		for n in shape_info:
			surface_array += n.get_surface_array(index_offset)
			index_offset = surface_array[Mesh.ARRAY_VERTEX].size()
		tri_count = surface_array[Mesh.ARRAY_INDEX].size() / 3
		array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)

func cull() -> void:
	pass
