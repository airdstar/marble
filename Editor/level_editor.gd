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


var selected_part : Node3D = null
var selected_shape : shape_resource = null
@onready var shape_preview : ProcMesh = $ShapePreview

@onready var level_select := $UI/LevelSelect
@onready var XYZpos := $XYZPos
@onready var camera : Camera3D = $CameraPivot/Camera3D

@onready var UI : Control = $UI

@onready var sections = $UI/Sections

signal level_loaded
signal shape_placed
signal new_part_selected
signal new_shape_selected

func _ready() -> void:
	shape_preview.is_preview = true
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

func part_selected(part : Node3D) -> void:
	var holder : Node3D
	if part is ProcMesh:
		if part.is_preview:
			holder = selected_part
	
	selected_part = part
	XYZpos.visible = true
	
	new_part_selected.emit(selected_part)

func reset_camera() -> void:
	$CameraPivot.rotation = Vector3(deg_to_rad(-10), 0, 0)


func level_selected(level_info : level_resource) -> void:
	chosen_level = level_info
	level_base = chosen_level.associated_scene.instantiate()
	add_child(level_base)
	level_base.open_editor()
	level_loaded.emit(level_base)
	UI.show_all()

func shape_selected(shape : shape_resource) -> void:
	selected_shape = shape
	shape_preview.clear_mesh()
	shape_preview.add_shape(shape)
	XYZpos.visible = true
	XYZpos.position = shape.total_offset
	new_shape_selected.emit(shape)

func shape_unselected() -> void:
	shape_preview.clear_mesh()
	selected_shape = null
	XYZpos.visible = false

func _on_place_pressed() -> void:
	if sections.selected_geometry != null:
		if selected_shape != null:
			selected_shape.locked = true
			sections.selected_geometry.add_shape(selected_shape)
			shape_placed.emit(selected_shape)
			shape_unselected()
			

func part_name_changed(new_text: String) -> void:
	if new_text != "":
		if selected_part is ProcMesh:
			selected_part.mesh_name == new_text
