extends MeshInstance3D
class_name ProcMesh

@export var body : StaticBody3D
@export var collider : CollisionShape3D
@export var shape_info : Array[shape_resource]
@export var array_mesh : ArrayMesh

var tri_count : int = 0

var is_preview := false

signal offset_change_successful
signal size_change_successful

func clear_mesh() -> void:
	shape_info.clear()
	tri_count = 0
	regenerate_mesh()

func add_shape(new_shape : shape_resource) -> void:
	shape_info.append(new_shape)
	regenerate_mesh()

func remove_shape(shape : shape_resource) -> void:
	for n : int in range(shape_info.size()):
		if shape_info[n] == shape:
			shape_info.remove_at(n)
			break
	regenerate_mesh()

func regenerate_mesh() -> void:
	if !array_mesh:
		array_mesh = ArrayMesh.new()
		mesh = array_mesh
	array_mesh.clear_surfaces()
	
	if shape_info.size() != 0:
		var index_offset : int = 0
		
		var surface_array : Array = []
		surface_array.resize(Mesh.ARRAY_MAX)
		var positions := PackedVector3Array()
		var normals := PackedVector3Array()
		var indices := PackedInt32Array()
		
		var surface_holder : Array
		for n in shape_info:
			surface_holder = n.get_surface_array(index_offset)
			
			positions.append_array(surface_holder[Mesh.ARRAY_VERTEX])
			normals.append_array(surface_holder[Mesh.ARRAY_NORMAL])
			indices.append_array(surface_holder[Mesh.ARRAY_INDEX])
			
			index_offset = positions.size()
			
		surface_array[Mesh.ARRAY_VERTEX] = positions
		surface_array[Mesh.ARRAY_NORMAL] = normals
		surface_array[Mesh.ARRAY_INDEX] = indices
		
		array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
		

func create_collision() -> void:
	collider.shape = array_mesh.create_trimesh_shape()

func cull() -> void:
	pass

func offset_changed(pos_change : Vector3) -> void:
	if shape_info.size() != 0:
		shape_info[0].total_offset = pos_change
		regenerate_mesh()
		offset_change_successful.emit(shape_info[0].total_offset)

func size_changed(new_size : Vector3) -> void:
	if shape_info.size() != 0:
		shape_info[0].size = new_size
		regenerate_mesh()
		size_change_successful.emit(shape_info[0].size)

func rotation_changed(new_rotation : Vector3) -> void:
	if shape_info.size() != 0:
		shape_info[0].rotation = new_rotation
		regenerate_mesh()
		

func name_changed(new_name : String) -> void:
	if shape_info.size() != 0:
		shape_info[0].shape_name = new_name

func sides_changed(value: float) -> void:
	shape_info[0].sides = value
	regenerate_mesh()

func orientation_changed(index : int) -> void:
	shape_info[0].orientation = index
	regenerate_mesh()

func flip_orientation_changed(toggled_on: bool) -> void:
	shape_info[0].flip_orientation = toggled_on
	regenerate_mesh()

func modifier_changed(index: int) -> void:
	shape_info[0].modifier = index
	regenerate_mesh()
