extends Node

enum section {
	GEOMETRY,
	STARTS,
	MISC
}

var allow_camera_movement := false

var chosen_level : level_resource
var level_base : level
var selected_section : section = section.GEOMETRY

var held_shape : shape_resource = null
var adjusting : editor.adjustable = editor.adjustable.NONE
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
	
	if Input.is_action_just_pressed("back"):
			print(selected_part)
			print(selected_shape)
			print(selected_tool)
			print(adjusting)
	
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

	level_loaded.emit(level_base)
	UI.show_all()

func part_selected(part : Node3D) -> void:
	var holder : Node3D
	if part is ProcMesh:
		if part.is_preview:
			holder = selected_part
	
	adjuster.selected_pos_changed(part.position)

	if part is not start and part is not ProcMesh:
		adjuster.selected_size_changed(Vector3(1,1,1) * part.scale)
	
	selected_part = part
	new_part_selected.emit(selected_part)

func part_unselected() -> void:
	selected_part = null
	adjusting = editor.adjustable.NONE
	tool_visible(false)

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
	if selected_part != null:
		UI.properties.part_selected(selected_part)

func _on_place_pressed() -> void:
	if sections.selected_part != null:
		if sections.selected_part is ProcMesh:
			if selected_shape != null:
				selected_shape.locked = true
				sections.selected_part.add_shape(selected_shape)
				shape_placed.emit(selected_shape)
				shape_unselected()
			

func switch_hold() -> void:
	if held_shape != null and held_shape != selected_shape:
		shape_selected(held_shape)
	else:
		shape_preview.remove_shape(selected_shape)
		held_shape = selected_shape
		selected_shape = null
		UI.properties.shape_unselected()
		tool_visible(false)


func new_procmesh_created() -> void:
	var holder = preload("res://Editor/Parts/ProcMesh.tscn").instantiate()
	new_part_created(holder)

func new_part_created(part : Node3D) -> void:
	level_base.parts.append(part)
	if part is ProcMesh:
		level_base.geometry.add_child(part)
	elif part is start:
		level_base.start_node.add_child(part)
	else:
		level_base.add_child(part)
	part.set_owner(level_base)
	sections.add_part(part, true)

func part_name_changed(new_text: String) -> void:
	if new_text != "":
		selected_part.set_meta("part_name", new_text)
		sections.get_selected_part().text = new_text

func movement_detected(pos_change : Vector3) -> void:
	match adjusting:
		editor.adjustable.PART:
			selected_part.position = pos_change
			adjuster.selected_pos_changed(pos_change)
			UI.properties.pos_changed(pos_change)
		editor.adjustable.SHAPE:
			shape_preview.offset_changed(pos_change)

func resize_detected(size_change : Vector3) -> void:
	match adjusting:
		editor.adjustable.PART:
			if selected_part is not start and selected_part is not endzone:
				selected_part.size = size_change
				UI.properties.size_changed(size_change)
		editor.adjustable.SHAPE:
			shape_preview.size_changed(size_change)

func property_group_set(adjust_to : String) -> void:
	match adjust_to:
		"Part":
			if selected_part is not ProcMesh:
				adjusting = editor.adjustable.PART
				tool_visible(true)
			else:
				tool_visible(false)
		"Shape":
			adjusting = editor.adjustable.SHAPE
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
	var adjust_to : String
	match adjusting:
		editor.adjustable.PART:
			adjust_to = "Part"
		editor.adjustable.SHAPE:
			adjust_to = "Shape"
	property_group_set(adjust_to)

func save_level() -> void:
	var to_save := PackedScene.new()
	to_save.pack(level_base)
	var saving = ResourceSaver.save(to_save, Global.level_scene_path + chosen_level.name + ".tscn")
	if saving != OK:
		print("Error with saving scene")
	else:
		chosen_level.associated_scene = ResourceLoader.load(Global.level_scene_path + chosen_level.name + ".tscn")
		
		saving = ResourceSaver.save(chosen_level, Global.level_resource_path + chosen_level.name + ".tres")
		if saving != OK:
			print("Error with saving resource")
	
