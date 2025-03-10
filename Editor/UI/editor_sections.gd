extends Control

var level_info : level

var selected_part : part
var selected_shape : shape_resource

var part_buttons : Array[Button]
var shape_buttons : Array[Button]

@export var tab_bar : TabBar

@export var geometry_holder : VBoxContainer
@export var shape_holder : VBoxContainer
@export var geometry_options : VBoxContainer

@export var part_holder : VBoxContainer

signal shape_selected
signal part_selected

signal part_unselected

func _on_level_loaded(loaded_level : level) -> void:
	level_info = loaded_level
	for n : part in loaded_level.parts:
		add_part(n, false)
	
	tab_changed(0)

func remove_selected() -> void:
	if selected_shape != null:
		for n in shape_buttons.size():
			if shape_buttons[n].button_pressed:
				shape_buttons[n].queue_free()
				shape_buttons.remove_at(n)
				if selected_part is geometry:
					selected_part.remove_shape(selected_shape)
				selected_shape = null
				break
	elif selected_part != null:
		for n in part_buttons.size():
			if part_buttons[n].button_pressed:
				part_buttons[n].queue_free()
				part_buttons.remove_at(n)
				level_info.parts.remove_at(level_info.parts.find(selected_part))
				if selected_part.is_start:
					level_info.starts.remove_at(level_info.starts.find(selected_part))
				selected_part.queue_free()
				selected_part = null
				for m : Button in shape_holder.get_children():
					m.queue_free()
				shape_buttons.clear()
				part_unselected.emit()
				break

func clear_all() -> void:
	selected_shape = null
	selected_part = null
	for n in part_buttons.size():
		part_buttons[0].queue_free()
		part_buttons.remove_at(0)
	for n in shape_buttons.size():
		shape_buttons[0].queue_free()
		shape_buttons.remove_at(0)
		

func add_part(_part : part, toggle_button : bool) -> void:
	var current_button : Button = Button.new()
	current_button.text = _part.part_name
	current_button.toggle_mode = true
	part_buttons.append(current_button)
	
	if _part is geometry:
		geometry_holder.add_child(current_button)
	else:
		part_holder.add_child(current_button)
	
	current_button.toggled.connect(part_toggled.bind(_part, current_button))
	
	if toggle_button:
		current_button.button_pressed = true

func part_toggled(toggled_on : bool, _part : part, button : Button) -> void:
	for n : Button in shape_holder.get_children():
		n.queue_free()
	if toggled_on:
		selected_part = _part
		
		for n : Button in part_buttons:
			if n != button:
				n.button_pressed = false
		
		if _part is geometry:
			for n : shape_resource in _part.get_shape_info():
				add_shape(n)
		
		part_selected.emit(_part)
		
	else:
		if _part == selected_part:
			selected_part = null
			part_unselected.emit()

func add_shape(shape_info : shape_resource):
	var shape_button : Button = Button.new()
	shape_button.text = shape_info.shape_name
	shape_button.toggle_mode = true
	shape_holder.add_child(shape_button)
	shape_button.toggled.connect(shape_toggled.bind(shape_info, shape_button))
	shape_buttons.append(shape_button)

func shape_toggled(toggled_on : bool, shape : shape_resource, button : Button) -> void:
	if toggled_on:
		selected_shape = shape
		
		for n : Button in shape_holder.get_children():
			if n == button:
				continue
			n.button_pressed = false
	else:
		selected_shape = null


func tab_changed(tab: int) -> void:
	shape_holder.visible = false
	geometry_holder.visible = false
	geometry_options.visible = false
	part_holder.visible = false
	match tab:
		0:
			geometry_holder.visible = true
			shape_holder.visible = true
			geometry_options.visible = true
		1:
			part_holder.visible = true


func _on_take_pressed() -> void:
	if selected_part != null:
		if selected_part is geometry:
			if selected_shape != null:
			
				selected_part.remove_shape(selected_shape)
				selected_shape.total_offset += selected_part.position
				shape_selected.emit(selected_shape)
				
				for n : Button in shape_holder.get_children():
					n.queue_free()
				
				for n : shape_resource in selected_part.get_shape_info():
					add_shape(n)
				selected_shape = null

func get_selected_part() -> Button:
	for n : Button in part_buttons:
		if n.button_pressed:
			return n
	return null
