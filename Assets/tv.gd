extends Node3D

@onready var screen = $Screen

var viewport : SubViewport = null

func _ready() -> void:
	pass

func assign_viewport(viewport_in : SubViewport):
	viewport = viewport_in
