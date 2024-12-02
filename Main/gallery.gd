extends Node

var allow_test : bool = false

var easy_veto : bool = false
var medium_veto : bool = false
var hard_veto : bool = false

var selected_tab : int = 0
var options : Array[Button] = []
var option_directories : Array[String] = []


@onready var easy : Button = $VBoxContainer/HBoxContainer/Easy
@onready var medium : Button = $VBoxContainer/HBoxContainer/Medium
@onready var hard : Button = $VBoxContainer/HBoxContainer/Hard
@onready var test : Button = $VBoxContainer/HBoxContainer/Test

func _ready():
	check_valid_difficulties()
	show_options()

func show_options():
	clear_options()
	var dir = DirAccess.open(Global.level_directories[selected_tab])
	dir.list_dir_begin()
	var currentLevel : String = dir.get_next()
	var allLevels : Array[String]
	while currentLevel != "":
		var holder = Button.new()
		holder.size_flags_vertical = 3
		options.append(holder)
		$VBoxContainer.add_child(holder)
		if '.tscn.remap' in currentLevel:
			currentLevel = currentLevel.trim_suffix('.remap')
		allLevels.append(Global.level_directories[RunInfo.currentDifficulty] + currentLevel)
		
		currentLevel = dir.get_next()
		
	dir.list_dir_end()
	return allLevels[randi_range(0, allLevels.size() - 1)]

func clear_options():
	for n in options:
		n.queue_free()
	options.clear()
	option_directories.clear()

func check_valid_difficulties() -> void:
	for n in range(4):
		var level_count : int = 0
		var dir : DirAccess = DirAccess.open(Global.level_directories[n])
		if dir != null:
			dir.list_dir_begin()
			var currentLevel : String = dir.get_next()
			while currentLevel != "":
				level_count += 1
				currentLevel = dir.get_next()
			dir.list_dir_end()
		match n:
			0:
				if level_count > 0 and !easy_veto:
					easy.disabled = false
				else:
					easy.disabled = true
			1:
				if level_count > 0 and !medium_veto:
					medium.disabled = false
				else:
					medium.disabled = true
			2:
				if level_count > 0 and !hard_veto:
					hard.disabled = false
				else:
					hard.disabled = true
			3:
				if allow_test:
					if level_count > 0:
						test.disabled = false
					else:
						test.disabled = true
				else:
					test.visible = false


func easy_pressed() -> void:
	selected_tab = 0
	show_options()

func medium_pressed() -> void:
	selected_tab = 1
	show_options()

func hard_pressed() -> void:
	selected_tab = 2
	show_options()
