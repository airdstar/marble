extends MeshInstance3D
class_name ProcMesh

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

func movement_detected(pos_change : Vector3) -> void:
	if pos_change.x != 0:
		shape_info[0].total_offset.x = pos_change.x
	
	if pos_change.y != 0:
		shape_info[0].total_offset.y = pos_change.y
	
	if pos_change.z != 0:
		shape_info[0].total_offset.z = pos_change.z
	
	if pos_change != Vector3.ZERO:
		regenerate_mesh()
