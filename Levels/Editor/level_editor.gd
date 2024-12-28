extends Node

enum section {
	GEOMETRY,
	STARTS,
	MISC
}

var allow_camera_movement := false

var chosen_level : level_resource

var selected_part 

var selected_section : section = section.GEOMETRY

@onready var level_base : RigidBody3D = $LevelBase

@onready var shape_preview = $shape_preview

@onready var pos_x = $CanvasLayer/VBoxContainer/Position/PosX
@onready var pos_y = $CanvasLayer/VBoxContainer/Position/PosY
@onready var pos_z = $CanvasLayer/VBoxContainer/Position/PosZ

@onready var scale_x = $CanvasLayer/VBoxContainer/Scale/ScaleX
@onready var scale_y = $CanvasLayer/VBoxContainer/Scale/ScaleY
@onready var scale_z = $CanvasLayer/VBoxContainer/Scale/ScaleZ

func _ready() -> void:
	pass

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
			$CameraPivot/Camera3D.position.z -= 10 * delta
			if $CameraPivot/Camera3D.position.z < 3:
				$CameraPivot/Camera3D.position.z = 3
		
		if Input.is_action_just_released("camera_zoom_out"):
			$CameraPivot/Camera3D.position.z += 10 * delta
			if $CameraPivot/Camera3D.position.z > 25:
				$CameraPivot/Camera3D.position.z = 25

func plane_pressed() -> void:
	shape_preview.clear_mesh()
	var new_shape = plane.new()
	
	new_shape
	new_shape.total_offset = preview_shape_pos()
	new_shape.size = preview_shape_scale()
	shape_preview.add_shape(new_shape)

func cube_pressed() -> void:
	shape_preview.clear_mesh()
	var new_shape = cube.new()
	new_shape.total_offset = preview_shape_pos()
	new_shape.size = preview_shape_scale()
	shape_preview.add_shape(new_shape)

func polygon_pressed() -> void:
	shape_preview.clear_mesh()
	var new_shape = polygon.new()
	new_shape.total_offset = preview_shape_pos()
	new_shape.size = preview_shape_scale()
	shape_preview.add_shape(new_shape)

func add_pressed() -> void:
	if selected_part is shape_resource:
		level_base.geometry.add_part(selected_part)

func preview_shape_pos_x_changed(value: float) -> void:
	#adjust_range()
	if shape_preview.shape_info.size() != 0:
		shape_preview.shape_info[0].total_offset.x = value
		shape_preview.regenerate_mesh()

func preview_shape_pos_y_changed(value: float) -> void:
	#adjust_range()
	if shape_preview.shape_info.size() != 0:
		shape_preview.shape_info[0].total_offset.y = value
		shape_preview.regenerate_mesh()

func preview_shape_pos_z_changed(value: float) -> void:
	#adjust_range()
	if shape_preview.shape_info.size() != 0:
		shape_preview.shape_info[0].total_offset.z = value
		shape_preview.regenerate_mesh()

func preview_shape_pos() -> Vector3:
	return Vector3(pos_x.value, pos_y.value, pos_z.value)

func preview_shape_scale_x_changed(value: float) -> void:
	#adjust_range()
	if shape_preview.shape_info.size() != 0:
		shape_preview.shape_info[0].size.x = value
		shape_preview.regenerate_mesh()

func preview_shape_scale_y_changed(value: float) -> void:
	#adjust_range()
	if shape_preview.shape_info.size() != 0:
		shape_preview.shape_info[0].size.y = value
		shape_preview.regenerate_mesh()

func preview_shape_scale_z_changed(value: float) -> void:
	#adjust_range()
	if shape_preview.shape_info.size() != 0:
		shape_preview.shape_info[0].size.z = value
		shape_preview.regenerate_mesh()

func preview_shape_scale() -> Vector3:
	return Vector3(scale_x.value, scale_y.value, scale_z.value)

func adjust_range() -> void:
	pos_x.max_value = 10 - scale_x.value
	pos_x.min_value = -(10 - scale_x.value)
	pos_y.max_value = 10 - scale_y.value
	pos_y.min_value = -(10 - scale_y.value)
	pos_z.max_value = 10 - scale_z.value
	pos_z.min_value = -(10 - scale_z.value)
	
	scale_x.max_value = 20 - abs(pos_x.value)
	scale_y.max_value = 20 - abs(pos_y.value)
	scale_z.max_value = 20 - abs(pos_z.value)

func reset_camera() -> void:
	$CameraPivot.rotation = Vector3.ZERO
