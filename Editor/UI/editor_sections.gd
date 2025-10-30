extends Control

var level_info : level

var selected_part : Button
var selected_shape : Button

var selected_shape_info : shape_resource

var part_buttons : Array[Button]
var shape_buttons : Array[Button]

@export var tab_bar : TabBar

@export var geometry_holder : VBoxContainer
@export var shape_holder : VBoxContainer
@export var geometry_options : VBoxContainer

@export var part_holder : VBoxContainer

signal select_part
signal select_shape

signal unselect_part

func level_loaded(loaded_level : level) -> void:
	level_info = loaded_level
	for n : part in loaded_level.parts:
		add_part(n, false)
	$Sections.modulate = Color(1.0, 1.0, 1.0, 0.0)

func delete_pressed() -> void:
	if selected_shape:
		for n : Button in $Sections/ScrollContainer/Shapes.get_children():
			if n.button_pressed:
				n.queue_free()
				selected_part.remove_shape(selected_shape)
				selected_shape = null
				return
	
	if selected_part:
		for n : Button in $Sections/ScrollContainer/Parts.get_children():
			if n.button_pressed:
				n.queue_free()
				level_info.parts.remove_at(level_info.parts.find(selected_part))
				if selected_part.is_start:
					level_info.starts.remove_at(level_info.starts.find(selected_part))
				selected_part.queue_free()
				%Info.unselect_part()
				return

func clear_all() -> void:
	selected_shape = null
	selected_part = null
	for n in $Sections/ScrollContainer/Parts.get_children():
		n.queue_free()
	for n in $Sections/ScrollContainer/Shapes.get_children():
		n.queue_free()

func add_part(_part : part, toggle_button : bool) -> void:
	var button := create_button()
	button.text = _part.part_name
	$Sections/ScrollContainer/Parts.add_child(button)
	button.toggled.connect(part_toggled.bind(_part, button))
	if toggle_button:
		if selected_part:
			selected_part.set_pressed_no_signal(false)
		button.button_pressed = true
	

func add_shape(shape_info : shape_resource):
	var button := create_button()
	button.text = shape_info.shape_name
	$Sections/ScrollContainer/Shapes.add_child(button)
	button.toggled.connect(shape_toggled.bind(shape_info, button))

func create_button() -> Button:
	var button := Button.new()
	button.custom_minimum_size.y = 45
	button.toggle_mode = true
	return button

func part_toggled(toggled_on : bool, _part : part, button : Button) -> void:
	if toggled_on:
		select_part.emit(_part)
		if selected_part:
			selected_part.set_pressed_no_signal(false)
		selected_part = button
		
		if _part is geometry:
			$Tabs/HBoxContainer/Shapes.disabled = false
			for n in $Sections/ScrollContainer/Shapes.get_children():
				n.queue_free()
			for n : shape_resource in _part.get_shape_info():
				add_shape(n)
			
		else:
			$Tabs/HBoxContainer/Shapes.disabled = true
	else:
		selected_part = null
		%Info.unselect_part()

func shape_toggled(toggled_on : bool, shape : shape_resource, button : Button) -> void:
	if toggled_on:
		selected_shape_info = shape
		if selected_shape:
			selected_shape.set_pressed_no_signal(false)
		selected_shape = button
	else:
		selected_shape = null



func tab(toggled_on : bool, _tab : int) -> void:
	if toggled_on:
		$Sections.modulate = Color(1.0, 1.0, 1.0, 1.0)
		if _tab == 0:
			$Sections/ScrollContainer/Shapes.hide()
			$Sections/ScrollContainer/Parts.show()
			$Tabs/HBoxContainer/Shapes.set_pressed_no_signal(false)
		else:
			$Sections/ScrollContainer/Parts.hide()
			$Sections/ScrollContainer/Shapes.show()
			$Tabs/HBoxContainer/Parts.set_pressed_no_signal(false)
	else:
		$Sections.modulate = Color(1.0, 1.0, 1.0, 0.0)

func _on_take_pressed() -> void:
	if selected_shape:
		%Info.select_shape(selected_shape_info)
		$Tabs/HBoxContainer/Shapes.remove_child(selected_shape)
		selected_shape = null
		selected_shape_info = null

func get_selected_part() -> Button:
	for n : Button in part_buttons:
		if n.button_pressed:
			return n
	return null
