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
@export var shape_preview : ProcMesh

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
		if !UI.level_select.visible:
			open_level_select()
		else:
			Global.open_scene("main_menu")
	
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
	chosen_level = null
	selected_part = null
	selected_shape = null
	held_shape = null
	sections.clear_all()
	adjusting = editor.adjustable.NONE
	selected_tool = editor.tool.NONE
	if level_base != null:
		level_base.queue_free()
		level_base = null
	UI.hide_all()
	for n in UI.level_select.option_container.get_children():
		n.button_pressed = false
	
	UI.level_select.visible = true

func reset_camera() -> void:
	$CameraPivot.rotation = Vector3(deg_to_rad(-10), 0, 0)

func level_selected(level_info : level_resource) -> void:
	chosen_level = level_info
	UI.settings.set_settings(level_info)
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

	if part is not ProcMesh:
		adjuster.selected_size_changed(part.scale)
	
	adjuster.selected_rotation_changed(part.rotation)
	
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
	adjuster.selected_rotation_changed(Vector3.ZERO)
	new_shape_selected.emit(shape)

func shape_unselected() -> void:
	shape_preview.clear_mesh()
	selected_shape = null
	if selected_part != null:
		UI.properties.part_selected(selected_part)

func _on_place_pressed() -> void:
	if selected_shape != null:
		if sections.selected_part != null:
			if sections.selected_part is ProcMesh:
				sections.selected_part.add_shape(selected_shape)
				shape_placed.emit(selected_shape)
				shape_unselected()
			else:
				create_and_place()
		else:
			create_and_place()

func create_and_place() -> void:
	new_procmesh_created()
	var proc_mesh_holder = level_base.geometry.get_child(level_base.geometry.get_child_count() - 1)
	proc_mesh_holder.add_shape(selected_shape)
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
	rec_set_owner(part)
	sections.add_part(part, true)

func rec_set_owner(part : Node3D) -> void:
	part.set_owner(level_base)
	for n in part.get_children():
		rec_set_owner(n)

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
			selected_part.scale = size_change
			UI.properties.size_changed(size_change)
			adjuster.selected_size_changed(size_change)
		editor.adjustable.SHAPE:
			shape_preview.size_changed(size_change)

func rotation_detected(rotation_change : Vector3) -> void:
	match adjusting:
		editor.adjustable.PART:
			selected_part.rotate_x(deg_to_rad(rotation_change.x))
			selected_part.rotate_y(deg_to_rad(rotation_change.y))
			selected_part.rotate_z(deg_to_rad(rotation_change.z))
			var part_rotation = Vector3(rad_to_deg(selected_part.rotation.x), rad_to_deg(selected_part.rotation.y), rad_to_deg(selected_part.rotation.z))
			UI.properties.rot_changed(part_rotation)
			adjuster.selected_rotation_changed(part_rotation)
		editor.adjustable.SHAPE:
			shape_preview.rotation_changed(rotation_change)

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
	adjuster.rot.visible = false
	if make_visible:
		match selected_tool:
			editor.tool.POS:
				adjuster.pos.visible = true
			editor.tool.SIZE:
				adjuster.size.visible = true
			editor.tool.ROTATION:
				adjuster.rot.visible = true

func tool_selected(tool : editor.tool) -> void:
	selected_tool = tool
	var adjust_to : String
	match adjusting:
		editor.adjustable.PART:
			adjust_to = "Part"
		editor.adjustable.SHAPE:
			adjust_to = "Shape"
	property_group_set(adjust_to)

func level_info_updated() -> void:
	if !UI.level_select.new_level.unavailable_names.has(UI.settings.name_field.text):
		
		var prev_name = chosen_level.name
		var holder = chosen_level.associated_scene

		chosen_level.name = UI.settings.name_field.text
		
		UI.level_select.new_level.unavailable_names.remove_at(UI.level_select.new_level.unavailable_names.find(prev_name))
		UI.level_select.new_level.unavailable_names.append(chosen_level.name)
		
		for n in UI.level_select.option_container.get_children():
			if n.button_pressed:
				n.queue_free()
		
		UI.level_select.add_level(chosen_level)
		
		DirAccess.remove_absolute(Global.level_resource_path + prev_name + ".tres")
		DirAccess.remove_absolute(Global.level_scene_path + prev_name + ".tscn")
		ResourceSaver.save(holder, Global.level_scene_path + chosen_level.name + ".tscn")
	if chosen_level.name == UI.settings.name_field.text:
		chosen_level.level_difficulty = UI.settings.difficulty_field.selected
		chosen_level.include_in_pool = UI.settings.include_box.button_pressed
		ResourceSaver.save(chosen_level, Global.level_resource_path + chosen_level.name + ".tres")
		UI.settings.close_settings()
	


func pre_save() -> void:
	for n in level_base.parts:
		if n is ProcMesh:
			n.create_collision()
	
	call_deferred("save_scene")

func save_scene() -> void:
	var node_to_save = level_base
	var to_save := PackedScene.new()
	to_save.pack(node_to_save)
	var saving = ResourceSaver.save(to_save, Global.level_scene_path + chosen_level.name + ".tscn")
	if saving != OK:
		print("Error with saving scene")
	else:
		chosen_level.associated_scene = to_save
		saving = ResourceSaver.save(chosen_level, Global.level_resource_path + chosen_level.name + ".tres")
		if saving != OK:
			print("Error with saving resource")
		else:
			chosen_level = ResourceLoader.load(Global.level_resource_path + chosen_level.name + ".tres")

func test_pressed() -> void:
	Global.open_floor(Global.floor_type.EDITOR, [ResourceLoader.load(Global.level_resource_path + chosen_level.name + ".tres")])
