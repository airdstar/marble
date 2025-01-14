extends Resource
class_name level_resource

## Name of the level
@export var name : String = "Name"

@export var level_difficulty : Global.difficulty = Global.difficulty.EASY

@export_enum("Platform", "2D") var level_type : int = 0

@export var associated_scene : PackedScene 

@export var include_in_pool : bool = false

@export_category("Experimental")

@export var gravity : Vector3 = Vector3(0, 9.8, 0)
