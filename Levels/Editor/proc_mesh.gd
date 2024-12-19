@tool
extends MeshInstance3D

@export var reload := false :
	set(new_reload):
		reload = false
		regenerate_mesh()

@export_enum("Plane", "Cube", "Sphere") var shape := 1 :
	set(new_shape):
		shape = new_shape
		regenerate_mesh()

@export_range(1,32) var subdivisions := 1 :
	set(new_subdivisions):
		subdivisions = new_subdivisions
		regenerate_mesh()

var array_mesh : ArrayMesh

func _ready() -> void:
	regenerate_mesh()

func regenerate_mesh() -> void:
	if !array_mesh:
		array_mesh = ArrayMesh.new()
		mesh = array_mesh
	array_mesh.clear_surfaces()
	var surface_array : Array
	match shape:
		0:
			pass
		1:
			surface_array = create_cube(subdivisions)
		2:
			surface_array = create_sphere(subdivisions)
	
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)

func create_plane(subdiv : int, index : int, direction : Vector3, center : Vector3) -> Array:
	var surface_array : Array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	
	var positions := PackedVector3Array()
	var normals := PackedVector3Array()
	var indices := PackedInt32Array()
	
	direction = direction.normalized()
	var binormal := Vector3(direction.z, direction.x, direction.y) / subdiv
	var tangent := binormal.rotated(direction, PI / 2.0)
	var offset := -subdiv * (binormal + tangent) / 2.0 + center
	
	for x : int in subdiv:
		for y : int in subdiv:
			var vert_offset := binormal * x + tangent * y + offset
			var ind_offset := 4 * (x * subdiv + y) + index
			
			positions.append_array([
				vert_offset,
				vert_offset + tangent,
				vert_offset + tangent + binormal,
				vert_offset + binormal
			])
			normals.append_array([
				direction,
				direction,
				direction,
				direction
			])
			indices.append_array([
				ind_offset, ind_offset + 1, ind_offset + 2,
				ind_offset, ind_offset + 2, ind_offset + 3
				])
	
	surface_array[Mesh.ARRAY_VERTEX] = positions
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices
	
	return surface_array

func create_cube(subdiv : int) -> Array:
	var surface_array : Array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	
	var positions := PackedVector3Array()
	var normals := PackedVector3Array()
	var indices := PackedInt32Array()
	
	const directions : PackedVector3Array = [
		Vector3.UP, Vector3.DOWN, Vector3.LEFT, Vector3.RIGHT, Vector3.FORWARD, Vector3.BACK
	]
	
	for n : int in directions.size():
		var index := 4 * n * subdiv * subdiv
		var plane := create_plane(subdiv, index, directions[n], directions[n] / 2.0)
		positions.append_array(plane[mesh.ARRAY_VERTEX])
		normals.append_array(plane[mesh.ARRAY_NORMAL])
		indices.append_array(plane[mesh.ARRAY_INDEX])
	
	surface_array[Mesh.ARRAY_VERTEX] = positions
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices
	
	return surface_array

func create_sphere(subdiv : int) -> Array:
	var surface_array := create_cube(subdiv)
	
	for n : int in surface_array[Mesh.ARRAY_VERTEX].size():
		var vertex : Vector3 = surface_array[Mesh.ARRAY_VERTEX][n]
		surface_array[Mesh.ARRAY_VERTEX][n] = vertex.normalized() / 2.0
		surface_array[Mesh.ARRAY_NORMAL][n] = vertex.normalized()
	
	return surface_array
