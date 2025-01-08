extends Node

enum section {
	GEOMETRY,
	STARTS,
	MISC
}

var allow_camera_movement := false

var chosen_level : level_resource
var level_base : RigidBody3D
var selected_section : section = section.GEOMETRY


var selected_part = null
@onready var selected_shape : ProcMesh = $SelectedShape

@onready var XYZpos = $XYZPos


@onready var camera : Camera3D = $CameraPivot/Camera3D



@onready var pos_x = $CanvasLayer/VBoxContainer/Position/PosX
@onready var pos_y = $CanvasLayer/VBoxContainer/Position/PosY
@onready var pos_z = $CanvasLayer/VBoxContainer/Position/PosZ

@onready var scale_x = $CanvasLayer/VBoxContainer/Scale/ScaleX
@onready var scale_y = $CanvasLayer/VBoxContainer/Scale/ScaleY
@onready var scale_z = $CanvasLayer/VBoxContainer/Scale/ScaleZ

func _ready() -> void:
	XYZpos.visible = false
	level_select()

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

func level_select():
	var holder = preload("res://Editor/LevelBase.tscn").instantiate()
	level_base = holder
	add_child(level_base)
	level_base.open_editor()

func part_selected() -> void:
	XYZpos.visible = true
	if selected_shape.shape_info.size() != 0:
		XYZpos.position = selected_shape.shape_info[0].total_offset

func plane_pressed() -> void:
	selected_shape.clear_mesh()
	var new_shape = plane.new()
	selected_shape.add_shape(new_shape)
	part_selected()

func cube_pressed() -> void:
	selected_shape.clear_mesh()
	var new_shape = cube.new()
	selected_shape.add_shape(new_shape)
	part_selected()

func polygon_pressed() -> void:
	selected_shape.clear_mesh()
	var new_shape = polygon.new()
	selected_shape.add_shape(new_shape)
	part_selected()

func add_pressed() -> void:
	if selected_part is shape_resource:
		level_base.geometry.add_part(selected_part)

func preview_shape_pos_x_changed(value: float) -> void:
	#adjust_range()
	if selected_shape.shape_info.size() != 0:
		selected_shape.shape_info[0].total_offset.x = value
		selected_shape.regenerate_mesh()

func preview_shape_pos_y_changed(value: float) -> void:
	#adjust_range()
	if selected_shape.shape_info.size() != 0:
		selected_shape.shape_info[0].total_offset.y = value
		selected_shape.regenerate_mesh()

func preview_shape_pos_z_changed(value: float) -> void:
	#adjust_range()
	if selected_shape.shape_info.size() != 0:
		selected_shape.shape_info[0].total_offset.z = value
		selected_shape.regenerate_mesh()

func preview_shape_pos() -> Vector3:
	return Vector3(pos_x.value, pos_y.value, pos_z.value)

func preview_shape_scale_x_changed(value: float) -> void:
	#adjust_range()
	if selected_shape.shape_info.size() != 0:
		selected_shape.shape_info[0].size.x = value
		selected_shape.regenerate_mesh()

func preview_shape_scale_y_changed(value: float) -> void:
	#adjust_range()
	if selected_shape.shape_info.size() != 0:
		selected_shape.shape_info[0].size.y = value
		selected_shape.regenerate_mesh()

func preview_shape_scale_z_changed(value: float) -> void:
	#adjust_range()
	if selected_shape.shape_info.size() != 0:
		selected_shape.shape_info[0].size.z = value
		selected_shape.regenerate_mesh()

func preview_shape_scale() -> Vector3:
	return Vector3(scale_x.value, scale_y.value, scale_z.value)

func reset_camera() -> void:
	$CameraPivot.rotation = Vector3(deg_to_rad(-10), 0, 0)
