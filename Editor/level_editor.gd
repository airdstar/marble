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
@onready var level_select : VBoxContainer = $UI/LevelSelect
@onready var XYZpos = $XYZPos
@onready var camera : Camera3D = $CameraPivot/Camera3D

signal level_loaded

func _ready() -> void:
	XYZpos.visible = false
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

func part_selected() -> void:
	XYZpos.visible = true
	if selected_part == null:
		XYZpos.position = selected_shape.shape_info[0].total_offset

func add_pressed() -> void:
	if selected_part is shape_resource:
		level_base.geometry.add_part(selected_part)

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

func reset_camera() -> void:
	$CameraPivot.rotation = Vector3(deg_to_rad(-10), 0, 0)


func level_selected(level_info : level_resource) -> void:
	chosen_level = level_info
	level_base = chosen_level.associated_scene.instantiate()
	add_child(level_base)
	level_base.open_editor()
	level_loaded.emit(level_base)

func shape_selected(shape : shape_resource) -> void:
	selected_shape.clear_mesh()
	selected_shape.add_shape(shape)
	part_selected()
