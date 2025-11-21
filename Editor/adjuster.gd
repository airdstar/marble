extends Node3D

enum state {
	IDLE,
	GRAB
}

enum tool {
	NONE,
	POS,
	ROT,
	SCALE
	
}

const RAY_LENGTH := 100

var current_tool : tool = tool.NONE
var current_state : state = state.IDLE
var grabbed : int = -1
var hovered : int = -1

@onready var axies : Array = [$X, $Y, $Z]
var axies_base : Array[Color] = [Color(1.0, 0.1, 0.1, 1.0), Color(0.1, 1.0, 0.1, 1.0), Color(0.1, 0.1, 1.0, 1.0)]
var axies_hover : Array[Color] = [Color(1.0, 0.4, 0.4, 1.0), Color(0.4, 1.0, 0.4, 1.0), Color(0.4, 0.4, 1.0, 1.0)]

var adj_pos : Array[float]
var adj_scale : Array[float]
var adj_rot : Array[float]


var initial_mouse_pos : Vector2
var initial_pos : Array[float]
var inital_rot : Vector3
var initial_scale : Vector3
var prev_mouse_pos : Vector2

var left_right_scale : float
var up_down_scale : float
var distance_scale : float = 1

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if %Info.adjusting == editor_info.adjustable.NONE:
		return
	set_adj()
	update_pos()
	update_rot()
	if grabbed != -1:
		match current_tool:
			tool.POS:
				grab_pos()
			tool.ROT:
				pass
			tool.SCALE:
				pass
	
	prev_mouse_pos = get_viewport().get_mouse_position()

func grab_pos() -> void:
	if initial_mouse_pos == get_viewport().get_mouse_position():
		return
	var dif = initial_mouse_pos - get_viewport().get_mouse_position()
	adj_pos[grabbed] = (initial_pos[grabbed] + (dif.x * left_right_scale  * distance_scale + dif.y * up_down_scale * distance_scale * 10))
	adj_pos[grabbed] = snapped(adj_pos[grabbed], 0.1)
	%Change.position(Vector3(adj_pos[0], adj_pos[1], adj_pos[2]))


func grab_rot() -> void:
	pass

func grab_scale() -> void:
	pass


func set_adj() -> void:
	adj_pos.clear()
	adj_scale.clear()
	adj_rot.clear()
	match %Info.adjusting:
		editor_info.adjustable.PART:
			adj_pos.append_array([%Info.selected_part.position.x, %Info.selected_part.position.y, %Info.selected_part.position.z])
			adj_scale.append_array([%Info.selected_part.scale.x, %Info.selected_part.scale.y, %Info.selected_part.scale.z])
			adj_rot.append_array([%Info.selected_part.rotation.x, %Info.selected_part.rotation.y, %Info.selected_part.rotation.z])
		editor_info.adjustable.SHAPE:
			adj_pos.append_array([%Info.selected_shape.total_offset.x, %Info.selected_shape.total_offset.y, %Info.selected_part.total_offset.z])
			adj_scale.append_array([%Info.selected_part.size.x, %Info.selected_part.size.y, %Info.selected_part.size.z])
			adj_rot = %Info.selected_shape.rotation.get_axis()

func update_pos() -> void:
	position = Vector3(adj_pos[0], adj_pos[1], adj_pos[2])
	if current_tool != tool.NONE:
		if current_tool == tool.SCALE:
			axies[0].position.x = adj_scale[0] / 2
			axies[1].position.y = adj_scale[1] / 2
			axies[2].position.z = adj_scale[2] / 2
		else:
			axies[0].position = Vector3(1,0,0)
			axies[1].position = Vector3(0,1,0)
			axies[2].position = Vector3(0,0,1)

func update_rot() -> void:
	if current_tool != tool.NONE:
		pass



func _input(event : InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				grabbed = hovered
				if grabbed != -1:
					current_state = state.GRAB
					initial_mouse_pos = get_viewport().get_mouse_position()
					initial_pos = [adj_pos[0], adj_pos[1], adj_pos[2]]
					
					prev_mouse_pos = get_viewport().get_mouse_position()
					var object_forward_direction = -axies[grabbed].global_transform.basis.z
					var direction_to_camera = (get_viewport().get_camera_3d().global_transform.origin - axies[grabbed].global_transform.origin).normalized()
					var cross_result = object_forward_direction.cross(direction_to_camera)
					left_right_scale = -cross_result.y
					up_down_scale = -cross_result.x
					var distance_from_camera = get_viewport().get_camera_3d().global_position.distance_to(axies[grabbed].global_position)
					distance_scale = distance_from_camera / 1000
					
					update_colors()
			else:
				current_state = state.IDLE
				grabbed = -1
				update_colors()

func set_tool(_tool : tool) -> void:
	current_tool = _tool
	set_visibility()

func set_visibility() -> void:
	var visible_mesh : Mesh = null
	var collider : Shape3D = null
	if %Info.adjusting != %Info.adjustable.NONE:
		set_adj()
		match current_tool:
			tool.POS:
				visible_mesh = BoxMesh.new()
				visible_mesh.size = Vector3(0.1, 0.1, 1.8)
				$X.look_at(Vector3(-40, adj_pos[1], adj_pos[2]))
				$Y.look_at(Vector3(adj_pos[0], -40, adj_pos[2]))
				$Z.look_at(Vector3.FORWARD)
				
				collider = BoxShape3D.new()
				collider.size = Vector3(0.3, 0.3, 2.0)
				
			tool.ROT:
				
				$X.look_at(Vector3(-40, adj_pos[1], adj_pos[2]))
				$Y.look_at(Vector3(adj_pos[0], -40, adj_pos[2]))
				$Z.look_at(Vector3.FORWARD)
				
			tool.SCALE:
				visible_mesh = SphereMesh.new()
				visible_mesh.radius = 0.1
				visible_mesh.height = 0.2
				visible_mesh.radial_segments = 16
				visible_mesh.rings = 8
				
				$X.look_at(Vector3(-40, adj_pos[1], adj_pos[2]))
				$Y.look_at(Vector3(adj_pos[0], -40, adj_pos[2]))
				$Z.look_at(Vector3.FORWARD)
				
				collider = BoxShape3D.new()
				collider.size = Vector3(0.3, 0.3, 0.3)
				
	
	for n in get_children():
		n.mesh = visible_mesh
		n.get_child(0).get_child(0).shape = collider

func update_colors() -> void:
	var used : int = -1
	if current_state == state.IDLE:
		if hovered != -1:
			axies[hovered].get_material_override().emission = axies_hover[hovered]
			used = hovered
	else:
		if grabbed != -1:
			axies[grabbed].get_material_override().emission = Color(1,1,1)
			used = grabbed
	for n in 3:
		if n == used:
			continue
		axies[n].get_material_override().emission = axies_base[n]

func enter(axis : int) -> void:
	hovered = axis
	update_colors()

func exit(axis: int) -> void:
	if hovered == axis:
		hovered = -1
	update_colors()
