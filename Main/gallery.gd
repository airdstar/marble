extends Node

enum sort_type {
	ID,
	TAGLINE,
	RANDOM
}

var allow_test : bool = false

var easy_veto : bool = false
var medium_veto : bool = false
var hard_veto : bool = false

var selected_tab : int = 1
var options : Array[Button] = []
var option_info : Array[level_resource] = []

var sort_by = sort_type.ID

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
	sort_options()

func create_option(option : level_resource) -> void:
	if (option.needs_testing and allow_test) or !option.needs_testing:
		
		var button_holder = Button.new()
		options.append(button_holder)
		button_holder.pressed.connect(option_pressed.bind(button_holder))
		$VBoxContainer/ScrollContainer/VBoxContainer.add_child(button_holder)
		
		set_option(button_holder, option)
		

func option_pressed(button):
	Global.main.start_gallery(option_info[options.find(button)])

func sort_options() -> void:
	pass

func set_option(button : Button, option : level_resource) -> void:
	var id : String = option.resource_path.trim_prefix("res://Levels/Info/")
	if '.tres.remap' in id:
		id = id.trim_suffix('.tres.remap')
	else:
		id = id.trim_suffix('.tres')
	
	#if option.needs_testing:
		#button.text = "TEST "
	
	if PlayerInfo.player_data.visited_levels.has(int(id)):
		button.text = option.tagline
	else:
		button.text = "???"
		button.disabled = true
	
	button.text += " ID: " + id

func clear_options() -> void:
	for n in options:
		n.queue_free()
	options.clear()

func check_valid_difficulties() -> void:
	if Global.easy_levels.size() > 0:
		easy.visible = true
	else:
		easy.visible = false
	
	if Global.medium_levels.size() > 0:
		medium.visible = true
	else:
		medium.visible = false
	
	if Global.hard_levels.size() > 0:
		hard.visible = true
	else:
		hard.visible = false

func easy_pressed() -> void:
	selected_tab = 1
	show_options()

func medium_pressed() -> void:
	selected_tab = 2
	show_options()

func hard_pressed() -> void:
	selected_tab = 3
	show_options()
