extends Node
class_name level

@export var given_time : float = 5.0
@export var start_pos : Array[Vector2] = [Vector2.ZERO]
@export var possible_rotations : Vector2 = Vector2(0,360)

@export_category("Experimental")

@export var tagline : String = "Test"
## Only change this if gravity can compensate it
@export var max_tilt : float = 35
@export var gravity : float

@export var end_pos : Array[Vector2]



func _ready():
	self.freeze = true
	max_tilt = deg_to_rad(max_tilt)
