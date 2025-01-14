extends Control

@onready var tools := $Tools
@onready var tools_container := $Tools/VBoxContainer

@onready var properties := $Properties
@onready var property_container := $Properties/VBoxContainer

@onready var parts := $Parts
@onready var part_container := $Parts/VBoxContainer

@onready var sections := $Sections
@onready var section_container := $Sections/VBoxContainer

@onready var level_select := $LevelSelect
@onready var level_select_container := $LevelSelect/VBoxContainer


func _ready() -> void:
	place_control()
	hide_all()
	level_select.visible = true

func place_control() -> void:
	level_select.set_size(Vector2(get_window().size.x / 5, get_window().size.y / 2))
	level_select_container.set_size(level_select.size)
	level_select.set_position(Vector2(get_window().size.x / 2 - level_select.size.x / 2, get_window().size.y / 4))
	
	

func hide_all() -> void:
	properties.visible = false
	parts.visible = false
	sections.visible = false
	tools.visible = false

func show_all() -> void:
	properties.visible = true
	sections.visible = true
	parts.visible = true
	tools.visible = true
