extends Node

var easy_veto : bool = false
var medium_veto : bool = false
var hard_veto : bool = false

var selected_tab : int = 1
var options : Array[Button] = []
var option_info : Array[level_resource] = []

@onready var easy : Button = $VBoxContainer/HBoxContainer/Easy
@onready var medium : Button = $VBoxContainer/HBoxContainer/Medium
@onready var hard : Button = $VBoxContainer/HBoxContainer/Hard

func _ready():
	check_valid_difficulties()
	show_options()

func show_options():
	clear_options()
	var dir = DirAccess.open("res://Levels/Info/")
	dir.list_dir_begin()
	var currentLevel : String = dir.get_next()
	while currentLevel != "":
		if '.tres.remap' in currentLevel:
			currentLevel = currentLevel.trim_suffix('.remap')
		
		if currentLevel.begins_with(str(selected_tab)):
			
			var resource_holder = ResourceLoader.load("res://Levels/Info/" + currentLevel)
			
			option_info.append(resource_holder)
			
			var button_holder = Button.new()
			button_holder.text = resource_holder.tagline + "   ID: " + str(currentLevel.trim_suffix('.tres')) 
			options.append(button_holder)
			$VBoxContainer/ScrollContainer/VBoxContainer.add_child(button_holder)
		
		currentLevel = dir.get_next()
	
	dir.list_dir_end()


func clear_options():
	for n in options:
		n.queue_free()
	options.clear()
	option_info.clear()

func check_valid_difficulties() -> void:
	var easy_enabled : bool = false
	var medium_enabled : bool = false
	var hard_enabled : bool = false
	
	var dir = DirAccess.open("res://Levels/Info/")
	dir.list_dir_begin()
	var currentLevel : String = dir.get_next()
	while currentLevel != "":
		if currentLevel.begins_with(str(1)) and !easy_enabled:
			easy_enabled = true
			easy.visible = true
		elif currentLevel.begins_with(str(2)) and !medium_enabled:
			medium_enabled = true
			medium.visible = true
		elif currentLevel.begins_with(str(3)) and !hard_enabled:
			hard_enabled = true
			hard.visible = true
		currentLevel = dir.get_next()

func easy_pressed() -> void:
	selected_tab = 1
	show_options()

func medium_pressed() -> void:
	selected_tab = 2
	show_options()

func hard_pressed() -> void:
	selected_tab = 3
	show_options()
