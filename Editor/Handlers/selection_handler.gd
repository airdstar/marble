extends Node

@export var master : Node
@export var UI : Control
@export var shape_preview : MeshInstance3D

var selected_part : part = null
var selected_shape : shape_resource = null
var held_shape : shape_resource = null
var selected_component : component = null

signal part_selected
signal shape_selected

func _part_selected(_part : part) -> void:
	
	master.adjuster.selected_pos_changed(_part.position)
	master.adjuster.selected_size_changed(_part.scale)
	master.adjuster.selected_rotation_changed(_part.rotation)
	
	selected_part = _part
	part_selected.emit(selected_part)

func _part_unselected() -> void:
	selected_part = null
	master.adjusting = editor.adjustable.NONE
	master.tool_visible(false)

func _shape_selected(shape : shape_resource) -> void:
	if selected_shape != null:
		held_shape = selected_shape
	
	selected_shape = shape
	shape_preview.clear_mesh()
	shape_preview.add_shape(shape)

	master.adjuster.selected_pos_changed(shape.total_offset)
	master.adjuster.selected_size_changed(shape.size)
	var e = shape.rotation.get_euler()
	master.adjuster.selected_rotation_changed(Vector3(rad_to_deg(e.x), rad_to_deg(e.y), rad_to_deg(e.z)))
	shape_selected.emit(shape)

func _shape_unselected() -> void:
	shape_preview.clear_mesh()
	selected_shape = null
	if selected_part != null:
		part_selected.emit(selected_part)

func switch_hold() -> void:
	if held_shape != null and held_shape != selected_shape:
		_shape_selected(held_shape)
	else:
		shape_preview.remove_shape(selected_shape)
		held_shape = selected_shape
		selected_shape = null
		UI.properties.shape_unselected()
		master.tool_visible(false)
