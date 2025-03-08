extends Node
class_name part

@export var part_name : String = "Part"

@export var collider : CollisionShape3D
@export var editor_visibility : Node3D
@export var not_scale : Node3D
@export var base : String


@export var is_start : bool = false
@export var is_pivot : bool = false

@export var translatable : bool = true
@export var scalable : bool = true
@export var rotatable : bool = true
