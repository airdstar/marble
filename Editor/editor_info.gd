extends Node
class_name editor_info

enum tool {
	NONE,
	POS,
	SIZE,
	ROTATION
}

enum adjustable {
	NONE,
	PART,
	SHAPE
}


var current_tool : tool = tool.NONE
var adjusting : adjustable = adjustable.NONE

var selected_part : part = null
var selected_shape : shape_resource = null
var held_shape : shape_resource = null

signal part_created
signal tool_selected

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

func unselect_part() -> void:
	selected_part = null
	%SelectedPart.text = "None"

func select_shape(shape : shape_resource) -> void:
	if selected_part and selected_part is geometry:
		selected_part.remove_shape(shape)
	if selected_shape:
		held_shape = selected_shape
	selected_shape = shape
	%SelectedShape.text = shape.shape_name
	%ShapePreview.clear_mesh()
	%ShapePreview.add_shape(shape)

func hold_shape() -> void:
	if selected_shape:
		held_shape = selected_shape
		%HeldShape.text = held_shape.shape_name
		selected_shape = null
		%ShapePreview.clear_mesh()
	elif held_shape:
		select_shape(held_shape)
		held_shape = null

func place_shape() -> void:
	if selected_shape:
		if !selected_part or !selected_part is geometry:
			create_part("res://Editor/Parts/Important/Geometry.tscn")
		%ShapePreview.clear_mesh()
		selected_part.add_shape(selected_shape)
		selected_shape = null

func set_adjusting(adjust : adjustable) -> void:
	adjusting = adjust

func set_tool(_tool : tool) -> void:
	current_tool = _tool
	tool_selected.emit()

func tool_visibility() -> void:
	if current_tool == tool.NONE:
		return
	


func clear_all() -> void:
	unselect_part()
	selected_shape = null
	held_shape = null
	set_tool(tool.NONE)
