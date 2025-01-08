extends Node

enum sort_type {
	ID,
	TAGLINE,
	RANDOM
}

var only_test : bool = false
var allow_test : bool = false

var selected_tab : int = 1
var options : Array[Button] = []
var option_info : Array[level_resource] = []

var sort_by = sort_type.ID

@onready var easy : Button = $VBoxContainer/HSplitContainer/HBoxContainer/Easy
@onready var medium : Button = $VBoxContainer/HSplitContainer/HBoxContainer/Medium
@onready var hard : Button = $VBoxContainer/HSplitContainer/HBoxContainer/Hard

func _ready() -> void:
	if only_test:
		allow_test = true
	check_valid_difficulties()
	show_options()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("back"):
		Global.open_scene(Global.main_scene.prev_scene)

func show_options() -> void:
	clear_options()
	match selected_tab:
		1:
			option_info = Global.easy_levels
		2:
			option_info = Global.medium_levels
		3:
			option_info = Global.hard_levels
	
	var total_removed = 0
	for n in range(option_info.size()):
		if only_test:
			if !option_info[n - total_removed].needs_testing:
				option_info.remove_at(n - total_removed)
				total_removed += 1
		else:
			if !allow_test and option_info[n - total_removed].needs_testing:
				option_info.remove_at(n - total_removed)
				total_removed += 1

	create_options()
	sort_options()

func create_options() -> void:
	for n in option_info:
		var button_holder = Button.new()
		options.append(button_holder)
		button_holder.pressed.connect(option_pressed.bind(button_holder))
		$VBoxContainer/ScrollContainer/VBoxContainer.add_child(button_holder)
		
		set_option(button_holder, n)
		

func option_pressed(button):
	Global.main.start_gallery("floor_gallery")

func sort_options() -> void:
	pass

func set_option(button : Button, option : level_resource) -> void:
	var id : String = option.resource_path.trim_prefix("res://Levels/Info/")
	if '.tres.remap' in id:
		id = id.trim_suffix('.tres.remap')
	else:
		id = id.trim_suffix('.tres')
	
	button.text = option.name + " ID: " + id

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
