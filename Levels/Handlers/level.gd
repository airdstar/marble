extends Node
class_name level

@export var level_id : int

@export var given_time : float = 5.0
@export var start_pos : Array[Vector2] = [Vector2.ZERO]
@export var possible_rotations : Vector2 = Vector2(0,360)
@export var tagline : String = "Test"

@export_category("Experimental")
## Only change this if gravity can compensate it
@export var max_tilt : float = 35
@export var gravity : Vector3 = Vector3(0, 9.8, 0)

@export_enum("Hi") var goal_type : String

@export var end_pos : Array[Vector2]



func _ready():
	self.freeze = true
	max_tilt = deg_to_rad(max_tilt)
