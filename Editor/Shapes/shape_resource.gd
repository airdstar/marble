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
@export var rotation := Vector3(1,0,0)

func set_mods() -> void:
	pass
