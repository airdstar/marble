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


var adjusting : editor.adjustable = editor.adjustable.NONE
var selected_tool : editor.tool = editor.tool.NONE

@export var shape_preview : MeshInstance3D

@export var camera_pivot : Node3D
@export var camera : Camera3D

@export_category("Handlers")
@export var shape_handler : Node
@export var selection_handler : Node
@export var UI : Control

@onready var adjuster := $Adjust

signal level_select

signal level_loaded

signal shape_placed
signal new_part_selected
signal new_shape_selected
signal all_non_pivots

func _ready() -> void:
	var material = StandardMaterial3D.new()
	material.backlight_enabled = true
	material.backlight = Color(1.0, 1.0, 1.0, 1.0)
	
	for n in range(29):
		var line = MeshInstance3D.new()
		line.mesh = BoxMesh.new()
		line.mesh.size = Vector3(0.005, 0.005, 28)
		line.position.x = n - 14
		line.mesh.material = material
		$Grid.add_child(line)
		
		line = MeshInstance3D.new()
		line.mesh = BoxMesh.new()
		line.mesh.size = Vector3(28, 0.005, 0.005)
		line.position.z = n - 14
		line.mesh.material = material
		$Grid.add_child(line)
	
	
	%Info.set_tool(editor_info.tool.NONE)
	level_select.emit()


func _process(delta : float) -> void:
	if Input.is_action_pressed("camera_right"):
		allow_camera_movement = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		allow_camera_movement = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.is_action_just_pressed("back"):
		if !%LevelSelect.visible:
			level_select.emit()
		else:
			Game.open_scene("res://Main/Menus/MainMenu.tscn")
	
	if Input.is_action_pressed("move_left"):
		camera_pivot.position += Vector3(-cos(camera_pivot.rotation.y),0, sin(camera_pivot.rotation.y)) * delta * 5
	
	if Input.is_action_pressed("move_right"):
		camera_pivot.position += Vector3(cos(camera_pivot.rotation.y),0, -sin(camera_pivot.rotation.y)) * delta * 5
	
	if Input.is_action_pressed("move_forward"):
		camera_pivot.position += Vector3(-sin(camera_pivot.rotation.y),0,-cos(camera_pivot.rotation.y)) * delta * 5
	
	if Input.is_action_pressed("move_backward"):
		camera_pivot.position += Vector3(sin(camera_pivot.rotation.y),0,cos(camera_pivot.rotation.y)) * delta * 5
	
	camera_pivot.position = camera_pivot.position.clamp(Vector3(-12.5,0,-12.5), Vector3(12.5,0,12.5))
	
	if allow_camera_movement:
		var input = Input.get_last_mouse_velocity()
		camera_pivot.rotation.y += -input.x * 0.002 * delta
		camera_pivot.rotation.x += -input.y * 0.002 * delta
		
		if Input.is_action_just_released("camera_zoom_in"):
			camera.position.z -= 100 * delta
			if camera.position.z < 0.1:
				camera.position.z = 0.1
		
		if Input.is_action_just_released("camera_zoom_out"):
			camera.position.z += 100 * delta
			if camera.position.z > 25:
				camera.position.z = 25

func open_level_select():
	chosen_level = null
	if level_base:
		level_base.queue_free()
	%Info.clear_all()

func level_selected(level_info : level_resource) -> void:
	chosen_level = level_info
	UI.settings.set_settings(level_info)
	level_base = chosen_level.associated_scene.instantiate()
	add_child(level_base)
	level_loaded.emit(level_base)
	%UI.level_selected()
	level_base.open_editor()
	print_orphan_nodes()
	

func _on_place_pressed() -> void:
	if selection_handler.selected_shape != null:
		if UI.sections.selected_part != null:
			if UI.sections.selected_part is geometry:
				UI.sections.selected_part.add_shape(selection_handler.selected_shape)
				shape_placed.emit(selection_handler.selected_shape)
				selection_handler._shape_unselected()
			else:
				create_and_place()
		else:
			create_and_place()

func create_and_place() -> void:
	var geometry_holder = new_geometry_created()
	geometry_holder.add_shape(selection_handler.selected_shape)
	shape_placed.emit(selection_handler.selected_shape)
	selection_handler._shape_unselected()

func new_geometry_created() -> geometry:
	var holder = preload("res://Editor/Parts/Important/Geometry.tscn").instantiate()
	
	return holder

func part_created(_part : part) -> void:
	level_base.parts.append(_part)
	if _part.is_start:
		level_base.starts.append(_part)
	level_base.add_child(_part)
	rec_set_owner(_part)
	if _part.collider:
		_part.collider.disabled = true


func reload_part() -> void:
	var info_holder : Array = []
	info_holder.append(%Info.selected_part.get_parent())
	info_holder.append(%Info.selected_part.scale)
	info_holder.append(%Info.selected_part.rotation)
	info_holder.append(%Info.selected_part.position)
	if %Info.selected_part is geometry:
		info_holder.append(%Info.selected_part.get_shape_info())
	
	var child_holder : Array = []
	for n in %Info.selected_part.get_children():
		child_holder.append(n)
	
	%Sections.delete()
	%Info.create_part(%Info.selected_part.base, info_holder, child_holder)


func rec_set_owner(_part : Node) -> void:
	_part.scene_file_path = ""
	_part.set_owner(level_base)
	for n in _part.get_children():
		rec_set_owner(n)

func part_rotation_toggled(toggled_on: bool) -> void:
	if selection_handler.selected_part != null:
		if toggled_on:
			var has_rot : bool = false
			for n in selection_handler.selected_part.get_children():
				if n is rotateable_component:
					has_rot = true
			if !has_rot:
				var rot = preload("res://Editor/Parts/Components/RotateableComponent.tscn").instantiate()
				selection_handler.selected_part.add_child(rot)
				rot.to_rotate = selection_handler.selected_part
				rot.set_owner(level_base)
				UI.properties.create_rotation_tab(rot)
		else:
			for n in selection_handler.selected_part.get_children():
				if n is rotateable_component:
					n.queue_free()
					if UI.properties.get_tab("Rotation") != -1:
						UI.properties.property_options.remove_tab(UI.properties.get_tab("Rotation"))

func part_movement_toggled(toggled_on : bool) -> void:
	pass

func get_all_non_pivot_parts() -> void:
	var to_return : Array[Node]
	
	for n in level_base.parts:
		if !n.is_pivot:
			to_return.append(n)
	
	all_non_pivots.emit(to_return)

func property_group_set(adjust_to : String) -> void:
	match adjust_to:
		"None":
			adjusting = editor.adjustable.NONE
			tool_visible(false)
		"Part":
			adjusting = editor.adjustable.PART
			tool_visible(true)
		"Shape":
			adjusting = editor.adjustable.SHAPE
			tool_visible(true)
		"Rotation":
			adjusting = editor.adjustable.NONE
			if selection_handler.selected_part != null:
				for n in selection_handler.selected_part.get_children():
					if n is rotateable_component:
						selection_handler.selected_component = n
			tool_visible(false)


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
		
		DirAccess.remove_absolute("res://Levels/LevelInfo/" + prev_name + ".tres")
		DirAccess.remove_absolute("res://Levels/LevelScene/" + prev_name + ".tscn")
		ResourceSaver.save(holder, "res://Levels/LevelScene/" + chosen_level.name + ".tscn")
	if chosen_level.name == UI.settings.name_field.text:
		chosen_level.level_difficulty = UI.settings.difficulty_field.selected
		chosen_level.include_in_pool = UI.settings.include_box.button_pressed
		ResourceSaver.save(chosen_level, "res://Levels/LevelInfo/" + chosen_level.name + ".tres")
		UI.settings.close_settings()

func pre_save() -> void:
	var furthest_point : float = 0
	for n in level_base.parts:
		if abs(n.position.x) + n.scale.x / 2 > furthest_point:
			furthest_point = abs(n.position.x) + n.scale.x / 2
		
		if abs(n.position.z) + n.scale.z / 2 > furthest_point:
			furthest_point = abs(n.position.z) + n.scale.z / 2
		
		if n is geometry:
			n.create_collision()
			for m in n.get_shape_info():
				if n.position.x + abs(m.total_offset.x) + m.size.x / 2 > furthest_point:
					furthest_point = n.position.x + abs(m.total_offset.x) + m.size.x / 2
				
				if n.position.z + abs(m.total_offset.z) + m.size.z / 2 > furthest_point:
					furthest_point = n.position.z + abs(m.total_offset.z) + m.size.z / 2
	chosen_level.camera_pos = clamp(furthest_point + 4, 0, 16.5)
	save_scene()

func save_scene() -> void:
	var to_save := PackedScene.new()
	to_save.pack(level_base)
	var saving = ResourceSaver.save(to_save, "res://Levels/LevelScene/" + chosen_level.name + ".tscn")
	if saving != OK:
		print("Error with saving scene")
	else:
		chosen_level.associated_scene = to_save
		saving = ResourceSaver.save(chosen_level, "res://Levels/LevelInfo/" + chosen_level.name + ".tres")
		if saving != OK:
			print("Error with saving resource")
		else:
			chosen_level = ResourceLoader.load("res://Levels/LevelInfo/" + chosen_level.name + ".tres")

func test_pressed() -> void:
	pre_save()
	Game.test(ResourceLoader.load("res://Levels/LevelInfo/" + chosen_level.name + ".tres"))
