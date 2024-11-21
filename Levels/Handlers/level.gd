extends Node

@export var given_time : float = 5.0
@export var start_pos : Array[Vector2] = [Vector2.ZERO]
@export var possible_rotations : Vector2

## Only change this if gravity can compensate it
@export var max_tilt : float = 35

@export var end_pos : Array[Vector2]

@export var gravity : float

func _ready():
	max_tilt = deg_to_rad(max_tilt)
