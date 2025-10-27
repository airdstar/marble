extends Control

@export_category("Tools")
@export var tools : Panel
@export var tools_container : VBoxContainer

@export_category("Properties")
@export var properties : Panel
@export var properties_container : VBoxContainer

@onready var sections : Panel = $Sections
@onready var sections_container := $Sections/VBoxContainer

@export_category("Options")
@export var options : Panel
@export var options_container : VBoxContainer

@export_category("Settings")
@export var settings : Panel
@export var settings_container : VBoxContainer



func _ready() -> void:
	place_control()
	hide_all()

func place_control() -> void:
	
	var left_border : int = get_window().size.x / 75
	var right_border : int = get_window().size.x * 74 / 75
	var top_border : int = get_window().size.y / 45
	var bottom_border : int = get_window().size.y * 44 / 45
	
	settings.set_size(Vector2(get_window().size.x / 5, get_window().size.y / 2))
	settings.set_position(Vector2(get_window().size.x / 2 - settings.size.x / 2, get_window().size.y / 4))
	settings_container.set_size(settings.size)
	
	tools.set_size(Vector2(get_window().size.x / 4, get_window().size.y / 20))
	tools.set_position(Vector2(get_window().size.x / 2 - tools.size.x / 2, top_border))
	tools_container.set_size(tools.size)
	
	options.set_size(Vector2(get_window().size.x / 4, get_window().size.y / 20))
	options.set_position(Vector2(right_border - options.size.x, top_border))
	options_container.set_size(options.size)
	
	sections.set_size(Vector2(get_window().size.x / 4, get_window().size.y / 1.25))
	sections.set_position(Vector2(right_border - sections.size.x, get_window().size.y / 10))
	sections_container.set_size(sections.size)

	properties.set_size(Vector2(get_window().size.x / 4, get_window().size.y / 2))
	properties.set_position(Vector2(left_border, bottom_border - properties.size.y))
	properties_container.set_size(properties.size)
	

func hide_all() -> void:
	properties.visible = false
	sections.visible = false
	tools.visible = false
	options.visible = false
	settings.visible = false

func show_all() -> void:
	sections.visible = true
	options.visible = true
	tools.visible = true
