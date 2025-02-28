extends Node
class_name part

enum type {
	NA,
	START,
	PIVOT
}

@export var collider : CollisionShape3D
@export var editor_visibility : Node3D
@export var base : String
@export var part_type : type = type.NA
