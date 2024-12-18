extends Resource
class_name level_resource

## Name of the level
@export var tagline : String = "Tagline"

## Possible rotations that the level can default to
@export var possible_rotations : Vector2 = Vector2(0,360)

@export_enum("Platform", "2D") var level_type : int = 0

@export var associated_scene : PackedScene 

@export var needs_testing : bool = true

@export_category("Experimental")

@export var max_tilt : float = 35
@export var gravity : Vector3 = Vector3(0, 9.8, 0)
