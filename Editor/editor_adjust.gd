extends Node3D

@onready var pos : Node3D = $Position
@onready var size : Node3D = $Size

@onready var pos_x : CollisionShape3D = $Position/X/Area3D/CollisionShape3D
@onready var pos_y : CollisionShape3D = $Position/Y/Area3D/CollisionShape3D
@onready var pos_z : CollisionShape3D = $Position/Z/Area3D/CollisionShape3D

@onready var size_x #: CollisionShape3D = $Size/X/Area3D/CollisionShape3D
@onready var size_y #: CollisionShape3D = $Size/Y/Area3D/CollisionShape3D
@onready var size_z #: CollisionShape3D = $Size/Z/Area3D/CollisionShape3D

var snapping := 0.5

var axis_grabbed : int = 0
const RAY_LENGTH := 40

signal pos_changed
signal size_changed

func _ready() -> void:
	pass

func _process(_delta : float) -> void:
	if pos.visible:
		if axis_grabbed != 0:
			var global_pos = get_mouse_world_position()
			if global_pos != null:
				match axis_grabbed:
					1:
						global_pos = Vector3(snapped(global_pos.x - 0.5, snapping), pos.position.y, pos.position.z)
					2:
						global_pos = Vector3(pos.position.x, snapped(global_pos.y - 0.5, snapping), pos.position.z)
					3:
						global_pos = Vector3(pos.position.x, pos.position.y, snapped(global_pos.z - 0.5, snapping))
				pos_changed.emit(global_pos)
	elif size.visible:
		if axis_grabbed != 0:
			var global_pos = get_mouse_world_position()
			if global_pos != null:
				match axis_grabbed:
					1:
						global_pos = Vector3(snapped(global_pos.x - 0.5, snapping), pos.position.y, pos.position.z)
					2:
						global_pos = Vector3(pos.position.x, snapped(global_pos.y - 0.5, snapping), pos.position.z)
					3:
						global_pos = Vector3(pos.position.x, pos.position.y, snapped(global_pos.z - 0.5, snapping))
				size_changed.emit(global_pos)
		

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


func selected_pos_changed(new_pos : Vector3) -> void:
	pos.position = new_pos

func x_pos_grabbed(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_action_released("editor_grab"):
				axis_grabbed = 0
				pos_x.shape.size = Vector3(0.95,0.25,0.25)
			else:
				axis_grabbed = 1
				pos_x.shape.size = Vector3(20,20,0.25)

func y_pos_grabbed(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_action_released("editor_grab"):
				axis_grabbed = 0
				pos_y.shape.size = Vector3(0.25,0.95,0.25)
			else:
				axis_grabbed = 2
				pos_y.shape.size = Vector3(20,20,0.25)
				
func z_pos_grabbed(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_action_released("editor_grab"):
				axis_grabbed = 0
				pos_z.shape.size = Vector3(0.25,0.25,0.95)
			else:
				axis_grabbed = 3
				pos_z.shape.size = Vector3(0.25,20,20)
