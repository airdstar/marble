extends Node3D
class_name boost

enum direction {
	FORWARD,
	UP
}

@export var type : direction = direction.FORWARD
@export var amount : int = 100
@export var delay : float = 0.5
