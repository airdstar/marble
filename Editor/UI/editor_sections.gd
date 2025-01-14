extends Control

var level_info : level

var selected_geometry : ProcMesh
var selected_shape : shape_resource

@onready var tab := $VBoxContainer/TabBar

@onready var geometry_holder : VBoxContainer = $VBoxContainer/HBoxContainer/ScrollContainer/VBoxContainer/Geometry
@onready var start_holder : VBoxContainer = $VBoxContainer/HBoxContainer/ScrollContainer/VBoxContainer/Starts
@onready var misc_holder : VBoxContainer = $VBoxContainer/HBoxContainer/ScrollContainer/VBoxContainer/Misc

@onready var shape_holder : VBoxContainer = $VBoxContainer/HBoxContainer/Shapes/VBoxContainer

signal shape_selected
signal part_selected

signal part_unselected
signal shape_unselected

func _ready() -> void:
	pass


func _on_level_loaded(loaded_level : level) -> void:
	level_info = loaded_level
	for n : ProcMesh in loaded_level.geometry.get_children():
		add_geometry(n)
	
	geometry_holder.get_child(0).button_pressed = true


func add_geometry(proc_mesh : ProcMesh) -> void:
	var current_button : Button = Button.new()
	current_button.text = proc_mesh.mesh_name
	
	current_button.toggle_mode = true
	geometry_holder.add_child(current_button)
	
	current_button.toggled.connect(geometry_section_selected.bind(proc_mesh, current_button))
	
func add_shape(shape_info : shape_resource):
	var shape_button : Button = Button.new()
	shape_button.text = shape_info.shape_name
	shape_button.toggle_mode = true
	shape_holder.add_child(shape_button)
	shape_button.toggled.connect(shape_chosen.bind(shape_info, shape_button))

func geometry_section_selected(toggled_on : bool, proc_mesh : ProcMesh, button : Button) -> void:
	for n : Button in shape_holder.get_children():
		n.queue_free()
	if toggled_on:
		
		selected_geometry = proc_mesh
	
		for n : Button in geometry_holder.get_children():
			if n == button:
				continue
			n.button_pressed = false
		
		for n : shape_resource in proc_mesh.shape_info:
			add_shape(n)
		
		part_selected.emit(selected_geometry)
	else:
		selected_geometry = null
		part_unselected.emit()
		

func shape_chosen(toggled_on : bool, shape : shape_resource, button : Button) -> void:
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
	start_holder.visible = false
	misc_holder.visible = false
	match tab:
		0:
			geometry_holder.visible = true
			shape_holder.visible = true
		1:
			start_holder.visible = true
		2:
			misc_holder.visible = true


func _on_new_mesh_pressed() -> void:
	var holder = preload("res://Editor/Shapes/ProcMesh.tscn").instantiate()
	level_info.geometry.add_child(holder)
	add_geometry(holder)


func _on_take_pressed() -> void:
	if selected_shape != null:
		selected_shape.locked = false
		shape_selected.emit(selected_shape)
		selected_geometry.remove_shape(selected_shape)
		
		for n : Button in shape_holder.get_children():
			n.queue_free()
		
		for n : shape_resource in selected_geometry.shape_info:
			add_shape(n)
		selected_shape = null

func get_selected_part() -> Button:
	match tab.current_tab:
		0:
			for n : Button in geometry_holder.get_children():
				if n.button_pressed:
					return n
		1:
			pass
	return null
