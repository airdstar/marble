extends Node
class_name main

var cur_scene : String
var prev_scene : String
var child_scene

func _ready() -> void:
	Global.set_main(self)
