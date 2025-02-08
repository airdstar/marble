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
@export var rotation : Quaternion = Quaternion.IDENTITY

func set_mods() -> void:
	pass

func apply_rotation(input : Array) -> Array:
	var to_return := []
	for n in input:
		to_return.append(n * rotation)
	return to_return

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
