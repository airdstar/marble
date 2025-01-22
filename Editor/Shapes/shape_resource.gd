extends Resource
class_name shape_resource

enum mod {
	NONE,
	HOLE,
	POINT
}

@export var locked : bool = false

@export var shape_name : String = "Shape"

@export var usable_mods : Dictionary = {
	"None" : mod.NONE
}

@export var modifier : mod = mod.NONE

@export var total_offset := Vector3.ZERO
@export var size := Vector3(1,1,1)
@export var rotation := Vector3(0,0,0)

func set_mods() -> void:
	pass

func apply_rotation(vertices : Array) -> Array:
	var to_return := []
	for n in vertices:
		var x_prime = (n.x * cos(rad_to_deg(rotation.z)) - n.y * sin(rad_to_deg(rotation.z)))
		var y_prime = (n.x * sin(rad_to_deg(rotation.z)) + n.y * cos(rad_to_deg(rotation.z)))
		#var z_prime = (-n.x * sin(rotation.y) + n.z * cos(rotation.y)) + (n.y * sin(rotation.x) + n.z * cos(rotation.x))
		to_return.append(Vector3(x_prime, y_prime, n.z))
	return to_return

func apply_size(vertices : Array) -> Array:
	var to_return := []
	for n in vertices:
		to_return.append(Vector3(n.x * size.x, n.y * size.y, n.z * size.z))
	return to_return

func apply_offset(vertices : Array) -> Array:
	var to_return := []
	for n in vertices:
		to_return.append(n + total_offset)
	return to_return
