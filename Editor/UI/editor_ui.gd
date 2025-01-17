extends Control

@onready var tools : Panel = $Tools
@onready var tools_container := $Tools/VBoxContainer

@onready var properties : Panel = $Properties
@onready var properties_container := $Properties/VBoxContainer

@onready var parts : Panel = $Parts
@onready var parts_container := $Parts/VBoxContainer

@onready var sections : Panel = $Sections
@onready var sections_container := $Sections/VBoxContainer

@onready var settings : Panel = $Settings
@onready var settings_container := $Settings/VBoxContainer

@onready var level_select : Panel = $LevelSelect
@onready var level_select_container := $LevelSelect/LevelSelect
@onready var level_select_new_container := $LevelSelect/NewLevel


func _ready() -> void:
	place_control()
	hide_all()
	level_select.visible = true

func place_control() -> void:
	
	var left_border : int = get_window().size.x / 75
	var right_border : int = get_window().size.x * 74 / 75
	var top_border : int = get_window().size.y / 45
	var bottom_border : int = get_window().size.y * 44 / 45
	
	level_select.set_size(Vector2(get_window().size.x / 5, get_window().size.y / 2))
	level_select.set_position(Vector2(get_window().size.x / 2 - level_select.size.x / 2, get_window().size.y / 4))
	level_select_container.set_size(level_select.size)
	level_select_new_container.set_size(level_select.size)
	
	tools.set_size(Vector2(get_window().size.x / 5, get_window().size.y / 20))
	tools.set_position(Vector2(get_window().size.x / 2 - tools.size.x / 2, top_border))
	tools_container.set_size(tools.size)
	
	settings.set_size(Vector2(get_window().size.x / 4, get_window().size.y / 20))
	settings.set_position(Vector2(right_border - settings.size.x, top_border))
	settings_container.set_size(settings.size)
	
	sections.set_size(Vector2(get_window().size.x / 4, get_window().size.y / 1.25))
	sections.set_position(Vector2(right_border - sections.size.x, get_window().size.y / 10))
	sections_container.set_size(sections.size)
	
	parts.set_size(Vector2(get_window().size.x / 4, get_window().size.y / 2))
	parts.set_position(Vector2(left_border, top_border))
	parts_container.set_size(parts.size)
	

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
