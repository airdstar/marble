extends Resource
class_name level_resource

## Name of the level
@export var name : String = "Name"

@export var level_difficulty : FloorLevel.difficulty = FloorLevel.difficulty.EASY

@export_enum("Platform", "2D") var level_type : int = 0

@export var associated_scene : PackedScene 

@export var include_in_pool : bool = false

@export_category("Experimental")

@export var camera_pos : float
