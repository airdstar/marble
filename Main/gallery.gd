extends Node

var allow_test : bool = true

var easy_veto : bool = false
var medium_veto : bool = false
var hard_veto : bool = false

var selected_tab : int = 1
var options : Array[Button] = []
var option_info : Array[level_resource] = []

@onready var easy : Button = $VBoxContainer/HBoxContainer/Easy
@onready var medium : Button = $VBoxContainer/HBoxContainer/Medium
@onready var hard : Button = $VBoxContainer/HBoxContainer/Hard

func _ready() -> void:
	check_valid_difficulties()
	show_options()

func show_options() -> void:
	clear_options()
	match selected_tab:
		1:
			option_info = Global.easy_levels
		2:
			option_info = Global.medium_levels
		3:
			option_info = Global.hard_levels
	
	for n in option_info:
		create_option(n)

func create_option(option : level_resource) -> void:
	if (option.needs_testing and allow_test) or !option.needs_testing:
		var button_holder = Button.new()
		if option.needs_testing:
			button_holder.text = "TEST "
		button_holder.text += option.tagline + "   ID: "
		
		var id : String = option.resource_path.trim_prefix("res://Levels/Info/")
		if '.tres.remap' in id:
			id = id.trim_suffix('.tres.remap')
		else:
			id = id.trim_suffix('.tres')
		button_holder.text += id
		
		options.append(button_holder)
		button_holder.pressed.connect(option_pressed.bind(button_holder))
		$VBoxContainer/ScrollContainer/VBoxContainer.add_child(button_holder)

func option_pressed(button):
	Global.main.start_gallery(option_info[options.find(button)])

func clear_options() -> void:
	for n in options:
		n.queue_free()
	options.clear()

func check_valid_difficulties() -> void:
	if Global.easy_levels.size() > 0:
		easy.visible = true
	
	if Global.medium_levels.size() > 0:
		medium.visible = true
	
	if Global.hard_levels.size() > 0:
		hard.visible = true

func easy_pressed() -> void:
	selected_tab = 1
	show_options()

func medium_pressed() -> void:
	selected_tab = 2
	show_options()

func hard_pressed() -> void:
	selected_tab = 3
	show_options()
