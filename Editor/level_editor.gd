extends Node

enum adjustable {
	PART,
	SHAPE
}

enum section {
	GEOMETRY,
	STARTS,
	MISC
}

var scene_path : String = "res://Levels/EditorTests/"
var resource_path : String = "res://Levels/EditorTests/LevelInfo/"

var allow_camera_movement := false

var chosen_level : level_resource
var level_base : level
var selected_section : section = section.GEOMETRY

var held_shape : shape_resource = null
var adjusting : adjustable = adjustable.PART
var selected_tool : editor.tool = editor.tool.NONE

var selected_part : Node3D = null
var selected_shape : shape_resource = null
@onready var shape_preview : ProcMesh = $ShapePreview

@onready var level_select := $UI/LevelSelect
@onready var adjuster := $Adjust
@onready var camera : Camera3D = $CameraPivot/Camera3D

@onready var UI : Control = $UI

@onready var sections = $UI/Sections

signal level_loaded
signal shape_placed
signal new_part_selected
signal new_shape_selected

func _ready() -> void:
	shape_preview.is_preview = true
	tool_visible(false)
	open_level_select()

func _process(delta : float) -> void:
	if Input.is_action_pressed("camera_right"):
		allow_camera_movement = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		allow_camera_movement = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if allow_camera_movement:
		var input = Input.get_last_mouse_velocity()
		$CameraPivot.rotation.y += -input.x * 0.002 * delta
		$CameraPivot.rotation.x += -input.y * 0.002 * delta
		
		if Input.is_action_just_released("camera_zoom_in"):
			camera.position.z -= 100 * delta
			if camera.position.z < 3:
				camera.position.z = 3
		
		if Input.is_action_just_released("camera_zoom_out"):
			camera.position.z += 100 * delta
			if camera.position.z > 25:
				camera.position.z = 25

func open_level_select():
	level_select.visible = true

func reset_camera() -> void:
	$CameraPivot.rotation = Vector3(deg_to_rad(-10), 0, 0)


func level_selected(level_info : level_resource) -> void:
	chosen_level = level_info
	level_base = chosen_level.associated_scene.instantiate()
	add_child(level_base)
	level_base.open_editor()
	
	if level_base.proc_mesh.size() == 0:
		var holder = preload("res://Editor/Shapes/ProcMesh.tscn").instantiate()
		level_base.proc_mesh.append(holder)
		level_base.geometry.add_child(holder)
	
	level_loaded.emit(level_base)
	UI.show_all()

func part_selected(part : Node3D) -> void:
	var holder : Node3D
	if part is ProcMesh:
		if part.is_preview:
			holder = selected_part
	


	selected_part = part
	new_part_selected.emit(selected_part)

func shape_selected(shape : shape_resource) -> void:
	if selected_shape != null:
		held_shape = selected_shape
	
	selected_shape = shape
	shape_preview.clear_mesh()
	shape_preview.add_shape(shape)

	adjuster.selected_pos_changed(shape.total_offset)
	adjuster.selected_size_changed(shape.size)
	new_shape_selected.emit(shape)

func shape_unselected() -> void:
	shape_preview.clear_mesh()
	selected_shape = null
	UI.properties.property_options.selected = 0
	UI.properties.property_group_changed(0)

func _on_place_pressed() -> void:
	if sections.selected_geometry != null:
		if selected_shape != null:
			selected_shape.locked = true
			sections.selected_geometry.add_shape(selected_shape)
			shape_placed.emit(selected_shape)
			shape_unselected()
			

func switch_hold() -> void:
	if held_shape != null and held_shape != selected_shape:
		shape_selected(held_shape)
	else:
		shape_preview.remove_shape(selected_shape)
		held_shape = selected_shape
		selected_shape = null
		tool_visible(false)
		

func new_procmesh_created() -> void:
	var holder = preload("res://Editor/Shapes/ProcMesh.tscn").instantiate()
	level_base.geometry.add_child(holder)
	level_base.proc_mesh.append(holder)
	sections.add_geometry(holder)

func part_name_changed(new_text: String) -> void:
	if new_text != "":
		if selected_part is ProcMesh:
			selected_part.mesh_name == new_text
			sections.get_selected_part().text = new_text

func movement_detected(pos_change : Vector3) -> void:
	match adjusting:
		adjustable.PART:
			selected_part.position = pos_change
			UI.properties.pos_changed(pos_change)
		adjustable.SHAPE:
			shape_preview.offset_changed(pos_change)

func resize_detected(size_change : Vector3) -> void:
	match adjusting:
		adjustable.PART:
			selected_part.size = size_change
			UI.properties.size_changed(size_change)
		adjustable.SHAPE:
			shape_preview.size_changed(size_change)

func property_group_set(adjust_to) -> void:
	if adjust_to == 0:
		if selected_part is not ProcMesh:
			adjusting = adjust_to
			tool_visible(true)
		else:
			tool_visible(false)
	else:
		adjusting = adjust_to
		tool_visible(true)

func tool_visible(make_visible : bool) -> void:
	adjuster.pos.visible = false
	adjuster.size.visible = false
	if make_visible:
		match selected_tool:
			editor.tool.POS:
				adjuster.pos.visible = true
			editor.tool.SIZE:
				adjuster.size.visible = true

func tool_selected(tool : editor.tool) -> void:
	selected_tool = tool
	property_group_set(adjusting)

func save_level() -> void:
	rec_set_owner(level_base)
	
	var to_save := PackedScene.new()
	to_save.pack(level_base)
	var saving = ResourceSaver.save(to_save, scene_path + chosen_level.name + ".tscn")
	if saving != OK:
		print("Error with scene")
	
	chosen_level.associated_scene = ResourceLoader.load(scene_path + chosen_level.name + ".tscn")
	
	saving = ResourceSaver.save(chosen_level, resource_path + chosen_level.name + ".tres")
	if saving != OK:
		print("Error with resource")
	

func rec_set_owner(parent_node : Node) -> void:
	for n in parent_node.get_children():
		n.owner = parent_node
		if n.get_child_count() != 0:
			rec_set_owner(n)
