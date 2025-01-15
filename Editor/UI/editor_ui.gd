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
	
	tools.set_size(Vector2(get_window().size.x / 5, get_window().size.y / 10))
	tools_container.set_size(tools.size)
	tools.set_position(Vector2(get_window().size.x / 2 - tools.size.x / 2, get_window.size.y / 20))

	sections.set_size(Vector2(get_window().size.x / 4, get_window().size.y / 1.25))
	section_container.set_size(sections.size)
	sections.set_position(Vector2(get_window().size.x * 19 / 20 - tools.size.x / 2, get_window.size.y / 20))

	
	

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
