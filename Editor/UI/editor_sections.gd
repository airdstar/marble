extends Control

var level_info : level

var shape_buttons : Array[Button] = []

@onready var geometry_holder : VBoxContainer = $VBoxContainer/HBoxContainer/ScrollContainer/VBoxContainer/Geometry
@onready var start_holder : VBoxContainer = $VBoxContainer/HBoxContainer/ScrollContainer/VBoxContainer/Starts
@onready var misc_holder : VBoxContainer = $VBoxContainer/HBoxContainer/ScrollContainer/VBoxContainer/Misc

@onready var shape_holder : VBoxContainer = $VBoxContainer/HBoxContainer/Shapes/VBoxContainer

signal shape_selected
signal part_selected

func _ready() -> void:
	pass


func _on_level_loaded(loaded_level : level) -> void:
	level_info = loaded_level
	for n : ProcMesh in loaded_level.geometry.get_children():
		add_geometry(n)


func add_geometry(proc_mesh : ProcMesh) -> void:
	var current_button : Button = Button.new()
	current_button.text = proc_mesh.mesh_name
	shape_buttons.append(current_button)
	current_button.toggle_mode = true
	geometry_holder.add_child(current_button)
	current_button.pressed.connect(geometry_section_selected.bind(proc_mesh))
	
		
func geometry_section_selected(proc_mesh : ProcMesh) -> void:
	for n in proc_mesh.shape_info:
		var shape_button : Button = Button.new()
		shape_button.text = n.shape_name
		shape_button.toggle_mode = true
		shape_holder.add_child(shape_button)
		shape_button.pressed.connect(shape_chosen.bind(n))

func shape_chosen(shape : shape_resource) -> void:
	shape_selected.emit(shape)



func tab_changed(tab: int) -> void:
	geometry_holder.visible = false
	start_holder.visible = false
	misc_holder.visible = false
	match tab:
		0:
			geometry_holder.visible = true
		1:
			start_holder.visible = true
		2:
			misc_holder.visible = true
