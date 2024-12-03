extends Resource
class_name level_resource

@export var tagline : String = "Test"


@export var given_time : float = 5.0
@export var start_pos : Array[Vector2] = [Vector2.ZERO]
@export var possible_rotations : Vector2 = Vector2(0,360)

@export_enum("Fall", "Paint") var goal_type : String = "Fall"

@export var associated_scene : PackedScene 

@export var needs_testing : bool = false

@export_category("Experimental")

@export var max_tilt : float = 35
@export var gravity : Vector3 = Vector3(0, 9.8, 0)

@export var end_pos : Array[Vector2]
