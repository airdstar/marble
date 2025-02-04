extends shape_resource
class_name polygon

@export_range(3, 32) var sides := 5

@export var point_direction := 1

@export var hole_size : float = 0.5
@export var hole_offset := Vector3.ZERO

var index_offset : int

func set_mods() -> void:
	var pos_mods : Dictionary = {
		"Hole" : mod.HOLE,
		"Point" : mod.POINT
	}

	usable_mods.merge(pos_mods, true)

func get_surface_array(index : int) -> Array:
	var surface_array : Array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	
	var positions := PackedVector3Array()
	var normals := PackedVector3Array()
	var indices := PackedInt32Array()
	
	index_offset = index
	
	var surface_holder := create_sides()

	positions.append_array(surface_holder[Mesh.ARRAY_VERTEX])
	normals.append_array(surface_holder[Mesh.ARRAY_NORMAL])
	indices.append_array(surface_holder[Mesh.ARRAY_INDEX])

	surface_holder = create_top_bottom()

	positions.append_array(surface_holder[Mesh.ARRAY_VERTEX])
	normals.append_array(surface_holder[Mesh.ARRAY_NORMAL])
	indices.append_array(surface_holder[Mesh.ARRAY_INDEX])
	
	positions = apply_size(positions)
	positions = apply_rotation(positions)
	normals = apply_rotation(normals)
	positions = apply_offset(positions)
	
	surface_array[Mesh.ARRAY_VERTEX] = positions
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices
	
	return surface_array

func create_top_bottom() -> Array:
	var to_return : Array = []
	to_return.resize(Mesh.ARRAY_MAX)

	var positions := PackedVector3Array()
	var normals := PackedVector3Array()
	var indices := PackedInt32Array()
	
	match modifier:
		mod.NONE:
			for n : float in sides:
				positions.append_array([
					Vector3(0, 0.5, 0),
					Vector3(cos(n/sides * PI * 2.0) / 2, 0.5, sin(n/sides * PI * 2.0) / 2),
					Vector3(cos((n + 1)/sides * PI * 2.0) / 2, 0.5, sin((n + 1)/sides * PI * 2.0) / 2)  
				])
				normals.append_array([
						Vector3.UP,
						Vector3.UP,
						Vector3.UP
					])
				indices.append_array([
					index_offset + 3 * n,
					index_offset + 1 + 3 * n,
					index_offset + 2 + 3 * n
					])
			
			index_offset += sides * 3
			
			for n : float in sides:
				positions.append_array([
					Vector3(0, -0.5, 0) ,
					Vector3(cos(n/sides * PI * 2.0) / 2, -0.5, sin(n/sides * PI * 2.0) / 2) ,
					Vector3(cos((n + 1)/sides * PI * 2.0) / 2, -0.5, sin((n + 1)/sides * PI * 2.0) / 2)  
				])
				normals.append_array([
						Vector3.DOWN,
						Vector3.DOWN,
						Vector3.DOWN
					])
				indices.append_array([
					index_offset + 2 + 3 * n,
					index_offset + 1 + 3 * n,
					index_offset + 3 * n
					])
			index_offset += sides * 3
		mod.HOLE:
			for n : float in sides:
				positions.append_array([
					Vector3(cos(n/sides * PI * 2.0) / 2 * hole_size + hole_offset.x, 0.5 + hole_offset.y, sin(n/sides * PI * 2.0) / 2 * hole_size + hole_offset.z),
					Vector3(cos((n + 1)/sides * PI * 2.0) / 2 * hole_size + hole_offset.x, 0.5 + hole_offset.y, sin((n + 1)/sides * PI * 2.0) / 2 * hole_size + hole_offset.z),
					Vector3(cos(n/sides * PI * 2.0) / 2, 0.5, sin(n/sides * PI * 2.0) / 2),
					Vector3(cos((n + 1)/sides * PI * 2.0) / 2, 0.5, sin((n + 1)/sides * PI * 2.0) / 2)
				])
				normals.append_array([
					Vector3.UP,
					Vector3.UP,
					Vector3.UP,
					Vector3.UP
					])
				indices.append_array([
					index_offset + 1 + 4 * n,
					index_offset + 0 + 4 * n,
					index_offset + 2 + 4 * n,
					index_offset + 1 + 4 * n,
					index_offset + 2 + 4 * n,
					index_offset + 3 + 4 * n
					])
		
			index_offset += sides * 4
			
			for n : float in sides:
				positions.append_array([
					Vector3(cos(n/sides * PI * 2.0) / 2 * hole_size + hole_offset.x, -0.5 + hole_offset.y, sin(n/sides * PI * 2.0) / 2 * hole_size + hole_offset.z),
					Vector3(cos((n + 1)/sides * PI * 2.0) / 2 * hole_size + hole_offset.x, -0.5 + hole_offset.y, sin((n + 1)/sides * PI * 2.0) / 2 * hole_size + hole_offset.z),
					Vector3(cos(n/sides * PI * 2.0) / 2, -0.5, sin(n/sides * PI * 2.0) / 2),
					Vector3(cos((n + 1)/sides * PI * 2.0) / 2, -0.5, sin((n + 1)/sides * PI * 2.0) / 2) 
				])
				normals.append_array([
						Vector3(cos(n/sides * PI * 2.0) / 2 * hole_size + hole_offset.x, -1 + hole_offset.y, sin(n/sides * PI * 2.0) / 2 * hole_size + hole_offset.z).normalized(),
						Vector3(cos((n + 1)/sides * PI * 2.0) / 2 * hole_size + hole_offset.x, -1 + hole_offset.y, sin((n + 1)/sides * PI * 2.0) / 2 * hole_size + hole_offset.z).normalized(),
						Vector3.DOWN,
						Vector3.DOWN
					])
				indices.append_array([
					index_offset + 4 * n,
					index_offset + 1 + 4 * n,
					index_offset + 2 + 4 * n,
					index_offset + 3 + 4 * n,
					index_offset + 2 + 4 * n,
					index_offset + 1 + 4 * n
					])
			
			index_offset += sides * 4
		mod.POINT:
			for n : float in sides:
				var a = Vector3(0, 0.5 * point_direction, 0)
				var b = Vector3(cos(n/sides * PI * 2.0) / -2, -0.5 * point_direction, sin(n/sides * PI * 2.0) / -2)
				var c = Vector3(cos((n + 1)/sides * PI * 2.0) / -2, -0.5 * point_direction, sin((n + 1)/sides * PI * 2.0) / -2)
				positions.append_array([
					a,
					b,
					c
				])
				normals.append_array([
						Vector3.UP * point_direction,
						Vector3.UP * point_direction,
						Vector3.UP * point_direction
					])
				indices.append_array([
					index_offset + 2 + 3 * n,
					index_offset + 3 * n,
					index_offset + 1 + 3 * n
					])
				
			index_offset += sides * 3
			
			for n : float in sides:
				positions.append_array([
					Vector3(0, -0.5 * point_direction, 0),
					Vector3(cos(n/sides * PI * 2.0) / -2, -0.5 * point_direction, sin(n/sides * PI * 2.0) / -2),
					Vector3(cos((n + 1)/sides * PI * 2.0) / -2, -0.5 * point_direction, sin((n + 1)/sides * PI * 2.0) / -2)  
				])
				normals.append_array([
						Vector3.DOWN * point_direction,
						Vector3.DOWN * point_direction,
						Vector3.DOWN * point_direction
					])
				indices.append_array([
					index_offset + 1 + 3 * n,
					index_offset + 3 * n,
					index_offset + 2 + 3 * n
					])
			
			index_offset += sides * 3
	
	to_return[Mesh.ARRAY_VERTEX] = positions
	to_return[Mesh.ARRAY_NORMAL] = normals
	to_return[Mesh.ARRAY_INDEX] = indices
	return to_return

func create_sides() -> Array:
	var to_return : Array = []
	to_return.resize(Mesh.ARRAY_MAX)

	var positions := PackedVector3Array()
	var normals := PackedVector3Array()
	var indices := PackedInt32Array()
	
	if modifier != mod.POINT:
		for n : float in sides:
			positions.append_array([
				Vector3(cos(n/sides * PI * 2.0) / 2, 0.5, sin(n/sides * PI * 2.0) / 2),
				Vector3(cos((n + 1)/sides * PI * 2.0) / 2, 0.5, sin((n + 1)/sides * PI * 2.0) / 2),
				Vector3(cos(n/sides * PI * 2.0) / 2, -0.5, sin(n/sides * PI * 2.0) / 2),
				Vector3(cos((n + 1)/sides * PI * 2.0) / 2, -0.5, sin((n + 1)/sides * PI * 2.0) / 2)  
				])
			normals.append_array([
				Vector3(cos((n + 0.5)/sides * PI * 2.0) / 2, 0, sin((n + 0.5)/sides * PI * 2.0) / 2),
				Vector3(cos((n + 0.5)/sides * PI * 2.0) / 2, 0, sin((n + 0.5)/sides * PI * 2.0) / 2),
				Vector3(cos((n + 0.5)/sides * PI * 2.0) / 2, 0, sin((n + 0.5)/sides * PI * 2.0) / 2),
				Vector3(cos((n + 0.5)/sides * PI * 2.0) / 2, 0, sin((n + 0.5)/sides * PI * 2.0) / 2)
				])
			indices.append_array([
				index_offset + 4 * n,
				index_offset + 2 + 4 * n,
				index_offset + 1 + 4 * n,
				index_offset + 1 + 4 * n,
				index_offset + 2 + 4 * n,
				index_offset + 3 + 4 * n
			])
		index_offset += 4 * sides

		match modifier:
			mod.HOLE:
				for n : float in sides:
					positions.append_array([
						Vector3(cos(n/sides * PI * 2.0) / 2 * hole_size + hole_offset.x, 0.5 + hole_offset.y, sin(n/sides * PI * 2.0) / 2 * hole_size + hole_offset.z),
						Vector3(cos((n + 1)/sides * PI * 2.0) / 2 * hole_size + hole_offset.x, 0.5 + hole_offset.y, sin((n + 1)/sides * PI * 2.0) / 2 * hole_size + hole_offset.z),
						Vector3(cos(n/sides * PI * 2.0) / 2 * hole_size + hole_offset.x, -0.5 + hole_offset.y, sin(n/sides * PI * 2.0) / 2 * hole_size + hole_offset.z),
						Vector3(cos((n + 1)/sides * PI * 2.0) / 2 * hole_size + hole_offset.x, -0.5 + hole_offset.y, sin((n + 1)/sides * PI * 2.0) / 2 * hole_size + hole_offset.z)  
					])
					normals.append_array([
							Vector3(cos((n + 0.5)/sides * PI * 2.0) / 2 * hole_size + hole_offset.x, 0, sin((n + 0.5)/sides * PI * 2.0) / 2 * hole_size + hole_offset.z),
							Vector3(cos((n + 0.5)/sides * PI * 2.0) / 2 * hole_size + hole_offset.x, 0, sin((n + 0.5)/sides * PI * 2.0) / 2 * hole_size + hole_offset.z),
							Vector3(cos((n + 0.5)/sides * PI * 2.0) / 2 * hole_size + hole_offset.x, 0, sin((n + 0.5)/sides * PI * 2.0) / 2 * hole_size + hole_offset.z),
							Vector3(cos((n + 0.5)/sides * PI * 2.0) / 2 * hole_size + hole_offset.x, 0, sin((n + 0.5)/sides * PI * 2.0) / 2 * hole_size + hole_offset.z)
						])
					indices.append_array([
						index_offset + 1 + 4 * n,
						index_offset + 2 + 4 * n,
						index_offset + 4 * n,
						index_offset + 3 + 4 * n,
						index_offset + 2 + 4 * n,
						index_offset + 1 + 4 * n
						])
				index_offset += 4 * sides
			
	
	to_return[Mesh.ARRAY_VERTEX] = positions
	to_return[Mesh.ARRAY_NORMAL] = normals
	to_return[Mesh.ARRAY_INDEX] = indices
	return to_return
	
