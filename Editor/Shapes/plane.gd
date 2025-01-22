extends shape_resource
class_name plane

@export_range(1,32) var subdivisions := 1

@export_enum("X", "Y", "Z") var orientation := 1
@export var flip_orientation := false

@export var center_offset := Vector3.ZERO

var direction : Vector3

func normalize_orientation():
	match orientation:
		0:
			if !flip_orientation:
				direction = Vector3.RIGHT
			else:
				direction = Vector3.LEFT
		1:
			if !flip_orientation:
				direction = Vector3.UP
			else:
				direction = Vector3.DOWN
		2:
			if !flip_orientation:
				direction = Vector3.BACK
			else:
				direction = Vector3.FORWARD

func get_surface_array(index : int) -> Array:
	var surface_array : Array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	
	var positions := PackedVector3Array()
	var normals := PackedVector3Array()
	var indices := PackedInt32Array()
	
	normalize_orientation()
	
	var binormal := Vector3(direction.z, direction.x, direction.y) / subdivisions
	var tangent := binormal.rotated(direction, PI / 2.0)
	var offset := -subdivisions * (binormal + tangent) / 2.0 + center_offset 
	
	for x : int in subdivisions:
		for y : int in subdivisions:
			var vert_offset := (binormal * x + tangent * y) + offset 
			var ind_offset := 4 * (x * subdivisions + y) + index
			positions.append_array([
				vert_offset,
				(vert_offset + tangent),
				(vert_offset + tangent + binormal),
				(vert_offset + binormal)
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
	
	positions = apply_rotation(positions)
	positions = apply_size(positions)
	positions = apply_offset(positions)
	
	
	surface_array[Mesh.ARRAY_VERTEX] = positions
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices
	
	return surface_array
