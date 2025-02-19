extends Node

@export var easy_button : Button
@export var medium_button : Button
@export var hard_button : Button

@export var tab_container : GridContainer
@export var option_container : VBoxContainer

@export var easy_container : VBoxContainer
@export var medium_container : VBoxContainer
@export var hard_container : VBoxContainer
func _ready() -> void:
	place_control()
	
	var dir = DirAccess.open(Global.level_resource_path)
	dir.list_dir_begin()
	var currentLevel : String = dir.get_next()
	while currentLevel != "":
		if '.remap' in currentLevel:
			currentLevel = currentLevel.trim_suffix('.remap')
		var holder = ResourceLoader.load(Global.level_resource_path + currentLevel)
		if holder.include_in_pool:
			var button = create_button(holder)
			match holder.level_difficulty:
				FloorLevel.difficulty.EASY:
					easy_container.add_child(button)
				FloorLevel.difficulty.MEDIUM:
					medium_container.add_child(button)
				FloorLevel.difficulty.HARD:
					hard_container.add_child(button)
		
		currentLevel = dir.get_next()
	dir.list_dir_end()
	
	if easy_container.get_child_count() == 0:
		easy_button.disabled = true
	
	if medium_container.get_child_count() == 0:
		medium_button.disabled = true
	
	if hard_container.get_child_count() == 0:
		hard_button.disabled = true
	
	tab_changed(0)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("back"):
		Global.open_scene(Global.main_scene.prev_scene)

func place_control() -> void:
	
	option_container.set_size(Vector2(get_window().size.x * 6 / 14, get_window().size.y / 1.2))
	option_container.set_position(Vector2(get_window().size.y / 30, get_window().size.y / 30))
	
	tab_container.set_custom_minimum_size(Vector2(0, get_window().size.y / 15))
	
func create_button(level_info : level_resource) -> Button:
	var to_return : Button = Button.new()
	to_return.text = level_info.name
	to_return.set_custom_minimum_size(Vector2(option_container.size.x / 1.5, get_window().size.y / 17.5))
	to_return.pressed.connect(level_selected.bind(level_info))
	return to_return

func level_selected(level_info : level_resource) -> void:
	Global.open_floor(Global.floor_type.GALLERY, [level_info])

func tab_changed(index : int) -> void:
	easy_container.visible = false
	medium_container.visible = false
	hard_container.visible = false
	
	match index:
		0:
			if !easy_button.disabled:
				easy_container.visible = true
			else:
				tab_changed(1)
		1:
			if !medium_button.disabled:
				medium_container.visible = true
			else:
				tab_changed(2)
		2:
			if !hard_button.disabled:
				hard_container.visible = true
			else:
				tab_changed(3)
		3:
			pass
