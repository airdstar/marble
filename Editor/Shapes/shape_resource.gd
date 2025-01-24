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
@export var x_rotation : float = 0
@export var y_rotation : float = 0
@export var z_rotation : float = 0

func set_mods() -> void:
	pass

func apply_x_rotation(input : Array) -> Array:
	var to_return := []
	for n in input:
		var y_prime = (n.y * cos(deg_to_rad(x_rotation)) - n.z * sin(deg_to_rad(x_rotation)))
		var z_prime = (n.y * sin(deg_to_rad(x_rotation)) + n.z * cos(deg_to_rad(x_rotation)))
		to_return.append(Vector3(n.x, y_prime, z_prime))
	return to_return

func apply_y_rotation(input : Array) -> Array:
	var to_return := []
	for n in input:
		var x_prime = (n.x * cos(deg_to_rad(y_rotation)) + n.z * sin(deg_to_rad(y_rotation)))
		var z_prime = (-n.x * sin(deg_to_rad(y_rotation)) + n.z * cos(deg_to_rad(y_rotation)))
		to_return.append(Vector3(x_prime, n.y, z_prime))
	return to_return

func apply_z_rotation(input : Array) -> Array:
	var to_return := []
	for n in input:
		var x_prime = (n.x * cos(deg_to_rad(z_rotation)) - n.y * sin(deg_to_rad(z_rotation)))
		var y_prime = (n.x * sin(deg_to_rad(z_rotation)) + n.y * cos(deg_to_rad(z_rotation)))
		to_return.append(Vector3(x_prime, y_prime, n.z))
	return to_return

func apply_rotation(input : Array) -> Array:
	input = apply_z_rotation(input)
	input = apply_y_rotation(input)
	input = apply_x_rotation(input)
	return input

func apply_size(input : Array) -> Array:
	var to_return := []
	for n in input:
		to_return.append(Vector3(n.x * size.x, n.y * size.y, n.z * size.z))
	return to_return

func apply_offset(input : Array) -> Array:
	var to_return := []
	for n in input:
		to_return.append(n + total_offset)
	return to_return
