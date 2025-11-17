extends Node
class_name editor_info

enum adjustable {
	NONE,
	PART,
	SHAPE
}

var adjusting : adjustable = adjustable.NONE

var selected_part : part = null
var selected_shape : shape_resource = null
var held_shape : shape_resource = null

signal part_created

signal part_selected

signal shape_selected
signal shape_unselected

func create_part(path : String, info : Array = [], children : Array = []) -> void:
	var holder = load(path)
	select_part(holder.instantiate())
	part_created.emit(selected_part)
	if !info.is_empty():
		selected_part.reparent(info[0])
		selected_part.scale = info[1]
		selected_part.rotation = info[2]
		selected_part.position = info[3]
		if selected_part is geometry:
			selected_part.set_shape_info(info[4])
		if !children.is_empty():
			for n in children:
				n.reparent(selected_part)

func select_part(_part : part) -> void:
	selected_part = _part
	%SelectedPart.text = _part.part_name
	part_selected.emit()

func unselect_part() -> void:
	selected_part = null
	%SelectedPart.text = "None"

func select_shape(shape : shape_resource) -> void:
	if selected_part and selected_part is geometry:
		selected_part.remove_shape(shape)
	if selected_shape:
		held_shape = selected_shape
	selected_shape = shape
	shape_selected.emit()
	%SelectedShape.text = shape.shape_name
	%ShapePreview.clear_mesh()
	%ShapePreview.add_shape(shape)
	

func unselect_shape() -> void:
	selected_shape = null
	%SelectedShape.text = "None"
	%ShapePreview.clear_mesh()
	shape_unselected.emit()

func hold_shape() -> void:
	if selected_shape:
		held_shape = selected_shape
		%HeldShape.text = held_shape.shape_name
		unselect_shape()
	elif held_shape:
		select_shape(held_shape)
		held_shape = null

func place_shape() -> void:
	if selected_shape:
		if !selected_part or !selected_part is geometry:
			create_part("res://Editor/Parts/Important/Geometry.tscn")
		selected_part.add_shape(selected_shape)
		%Sections.add_shape(selected_shape, true)
		unselect_shape()

func set_adjusting(adjust : adjustable) -> void:
	adjusting = adjust
	%Adjust.set_visibility()

func clear_all() -> void:
	unselect_part()
	selected_shape = null
	held_shape = null
	adjusting = adjustable.NONE
	%Adjust.set_tool(%Adjust.tool.NONE)
