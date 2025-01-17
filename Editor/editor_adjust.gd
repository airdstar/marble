extends Node3D

@onready var pos : Node3D = $Position
@onready var size : Node3D = $Size

@onready var pos_x : CollisionShape3D = $Position/X/Area3D/CollisionShape3D
@onready var pos_y : CollisionShape3D = $Position/Y/Area3D/CollisionShape3D
@onready var pos_z : CollisionShape3D = $Position/Z/Area3D/CollisionShape3D
@onready var pos_x_mesh : MeshInstance3D = $Position/X
@onready var pos_y_mesh : MeshInstance3D = $Position/Y
@onready var pos_z_mesh : MeshInstance3D = $Position/Z

@onready var size_x : CollisionShape3D = $Size/X/Area3D/CollisionShape3D
@onready var size_y : CollisionShape3D = $Size/Y/Area3D/CollisionShape3D
@onready var size_z : CollisionShape3D = $Size/Z/Area3D/CollisionShape3D
@onready var size_x_mesh : MeshInstance3D = $Size/X
@onready var size_y_mesh : MeshInstance3D = $Size/Y
@onready var size_z_mesh : MeshInstance3D = $Size/Z

var snapping := 0.5
var pos_cap := 10
var size_cap := 20

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
						global_pos = Vector3(clamp(snapped(global_pos.x - 0.5, snapping), -pos_cap, pos_cap), pos.position.y, pos.position.z)
					2:
						global_pos = Vector3(pos.position.x, clamp(snapped(global_pos.y - 0.5, snapping), -pos_cap, pos_cap), pos.position.z)
					3:
						global_pos = Vector3(pos.position.x, pos.position.y, clamp(snapped(global_pos.z - 0.5, snapping), -pos_cap, pos_cap))
				pos_changed.emit(global_pos)
	elif size.visible:
		if axis_grabbed != 0:
			var global_pos = get_mouse_world_position()
			if global_pos != null:
				match axis_grabbed:
					1:
						global_pos = Vector3(clamp(snapped((global_pos.x - position.x) * 2, snapping), snapping, size_cap), size_y_mesh.position.y * 2, size_z_mesh.position.z * 2)
					2:
						global_pos = Vector3(size_x_mesh.position.x * 2, clamp(snapped((global_pos.y - position.y) * 2, snapping), snapping, size_cap), size_z_mesh.position.z * 2)
					3:
						global_pos = Vector3(size_x_mesh.position.x * 2, size_y_mesh.position.y * 2, clamp(snapped((global_pos.z - position.z) * 2, snapping), snapping, size_cap))
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
	position = new_pos

func selected_size_changed(new_size : Vector3) -> void:
	size_x_mesh.position.x = new_size.x / 2
	size_y_mesh.position.y = new_size.y / 2
	size_z_mesh.position.z = new_size.z / 2

func x_pos_grabbed(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_action_released("editor_grab"):
				axis_grabbed = 0
				pos_x.shape.size = Vector3(0.95,0.25,0.25)
				pos_x_mesh.mesh.material.albedo_color = Color(0.85, 0, 0.1)
			else:
				axis_grabbed = 1
				pos_x.shape.size = Vector3(20,20,0.25)
				pos_x_mesh.mesh.material.albedo_color = Color(1, 0.3, 0.45)
				

func y_pos_grabbed(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_action_released("editor_grab"):
				axis_grabbed = 0
				pos_y.shape.size = Vector3(0.25,0.95,0.25)
				pos_y_mesh.mesh.material.albedo_color = Color(0, 0.85, 0.1)
			else:
				axis_grabbed = 2
				pos_y.shape.size = Vector3(20,20,0.25)
				pos_y_mesh.mesh.material.albedo_color = Color(0.3, 1, 0.45)
				
func z_pos_grabbed(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_action_released("editor_grab"):
				axis_grabbed = 0
				pos_z.shape.size = Vector3(0.25,0.25,0.95)
				pos_z_mesh.mesh.material.albedo_color = Color(0.1, 0, 0.85)
			else:
				axis_grabbed = 3
				pos_z.shape.size = Vector3(0.25,20,20)
				pos_z_mesh.mesh.material.albedo_color = Color(0.45, 0.3, 1)

func x_size_grabbed(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_action_released("editor_grab"):
				axis_grabbed = 0
				size_x.shape.size = Vector3(0.95,0.25,0.25)
				size_x_mesh.mesh.material.albedo_color = Color(0.85, 0, 0.1)
			else:
				axis_grabbed = 1
				size_x.shape.size = Vector3(20,20,0.25)
				size_x_mesh.mesh.material.albedo_color = Color(1, 0.3, 0.45)

func y_size_grabbed(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_action_released("editor_grab"):
				axis_grabbed = 0
				size_y.shape.size = Vector3(0.25,0.95,0.25)
				size_y_mesh.mesh.material.albedo_color = Color(0, 0.85, 0.1)
			else:
				axis_grabbed = 2
				size_y.shape.size = Vector3(20,20,0.25)
				size_y_mesh.mesh.material.albedo_color = Color(0.3, 1, 0.45)

func z_size_grabbed(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_action_released("editor_grab"):
				axis_grabbed = 0
				size_z.shape.size = Vector3(0.25,0.25,0.95)
				size_z_mesh.mesh.material.albedo_color = Color(0.1, 0, 0.85)
			else:
				axis_grabbed = 3
				size_z.shape.size = Vector3(0.25,20,20)
				size_z_mesh.mesh.material.albedo_color = Color(0.45, 0.3, 1)
