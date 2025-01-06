extends Node3D

@onready var X : MeshInstance3D = $X
@onready var Y : MeshInstance3D = $Y
@onready var Z : MeshInstance3D = $Z

@onready var Xcol : CollisionShape3D = $X/Area3D/CollisionShape3D
@onready var Ycol : CollisionShape3D = $Y/Area3D/CollisionShape3D
@onready var Zcol : CollisionShape3D = $Z/Area3D/CollisionShape3D


var axis_grabbed : int = 0
var master
const RAY_LENGTH := 40

func _ready() -> void:
	master = get_parent()

func _process(_delta: float) -> void:
	if axis_grabbed != 0:
		var global_pos = get_mouse_world_position()
		if global_pos != null:
			match axis_grabbed:
				1:
					master.selected_position_changed(axis_grabbed - 1, Vector3(snapped(global_pos.x - 0.5, 0.5),0,0))
				2:
					master.selected_position_changed(axis_grabbed - 1, Vector3(0,snapped(global_pos.y - 0.5, 0.5),0))
				3:
					master.selected_position_changed(axis_grabbed - 1, Vector3(0,0,snapped(global_pos.z - 0.5, 0.5)))


func _do_raycast_on_mouse_position(collision_mask: int = 0b00000000_00000000_00000000_00000001):
	# Raycast related code
	var space_state = get_world_3d().direct_space_state
	var cam = get_viewport().get_camera_3d()
	var mousepos = get_viewport().get_mouse_position()

	var origin = cam.project_ray_origin(mousepos)
	var end = origin + cam.project_ray_normal(mousepos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	query.collision_mask = collision_mask
	
	var result = space_state.intersect_ray(query) # raycast result
	return result

func get_mouse_world_position(collision_mask: int = 0b00000000_00000000_00000000_00000001):
	var raycast_result = _do_raycast_on_mouse_position(collision_mask)
	if raycast_result:
		return raycast_result.position
	return null

func x_clicked(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_action_released("editor_grab"):
				axis_grabbed = 0
				Xcol.shape.size = Vector3(0.95,0.25,0.25)
			else:
				axis_grabbed = 1
				Xcol.shape.size = Vector3(20,20,0.25)

func y_clicked(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_action_released("editor_grab"):
				axis_grabbed = 0
				Ycol.shape.size = Vector3(0.25,0.95,0.25)
			else:
				axis_grabbed = 2
				Ycol.shape.size = Vector3(20,20,0.25)
				

func z_clicked(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_action_released("editor_grab"):
				axis_grabbed = 0
				Zcol.shape.size = Vector3(0.25,0.25,0.95)
			else:
				axis_grabbed = 3
				Zcol.shape.size = Vector3(0.25,20,20)
