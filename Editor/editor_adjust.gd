extends Node3D
@export_category("Bases")
@export var pos : Node3D
@export var size : Node3D
@export var rot : Node3D

@export_category("Positional")
@export var pos_x : CollisionShape3D
@export var pos_y : CollisionShape3D
@export var pos_z : CollisionShape3D
@export var pos_x_mesh : MeshInstance3D
@export var pos_y_mesh : MeshInstance3D
@export var pos_z_mesh : MeshInstance3D

@export_category("Sizing")
@export var size_x : CollisionShape3D
@export var size_y : CollisionShape3D
@export var size_z : CollisionShape3D
@export var size_x_mesh : MeshInstance3D
@export var size_y_mesh : MeshInstance3D
@export var size_z_mesh : MeshInstance3D

@export_category("Rotational")
@export var rot_proxy : Node3D
@export var rot_x : CollisionShape3D
@export var rot_y : CollisionShape3D
@export var rot_z : CollisionShape3D
@export var rot_x_mesh : MeshInstance3D
@export var rot_y_mesh : MeshInstance3D
@export var rot_z_mesh : MeshInstance3D

var default_color : Array[Color] = [
	Color(0.85, 0, 0.1), 
	Color(0, 0.85, 0.1), 
	Color(0.1, 0, 0.85)
]


var selected_color : Array[Color] = [
	Color(1, 0.3, 0.45),
	Color(0.3, 1, 0.45),
	Color(0.45, 0.3, 1)
]

const MAX_POS : float = 12.5
const MAX_SIZE : float = 25

var prev_rotation : float = 0
var snapping := 0.1
var pos_cap_x := MAX_POS
var pos_cap_y := MAX_POS
var pos_cap_z := MAX_POS
var size_cap_x := MAX_SIZE
var size_cap_y := MAX_SIZE
var size_cap_z := MAX_SIZE

var axis_grabbed : int = 0
const RAY_LENGTH := 100

signal pos_changed
signal size_changed
signal rot_changed

func _ready() -> void:
	$Position/X/Area3D.input_event.connect(grabbed.bind(pos_x.shape.size, 1, pos_x_mesh, pos_x))
	$Position/Y/Area3D.input_event.connect(grabbed.bind(pos_y.shape.size, 2, pos_y_mesh, pos_y))
	$Position/Z/Area3D.input_event.connect(grabbed.bind(pos_z.shape.size, 3, pos_z_mesh, pos_z))
	$Size/X/Area3D.input_event.connect(grabbed.bind(size_x.shape.size, 1, size_x_mesh, size_x))
	$Size/Y/Area3D.input_event.connect(grabbed.bind(size_y.shape.size, 2, size_y_mesh, size_y))
	$Size/Z/Area3D.input_event.connect(grabbed.bind(size_z.shape.size, 3, size_z_mesh, size_z))
	$Rotation/X/Area3D.input_event.connect(grabbed.bind(rot_x.shape.size, 1, rot_x_mesh, rot_x))
	$Rotation/Y/Area3D.input_event.connect(grabbed.bind(rot_y.shape.size, 2, rot_y_mesh, rot_y))
	$Rotation/Z/Area3D.input_event.connect(grabbed.bind(rot_z.shape.size, 3, rot_z_mesh, rot_z))

func _physics_process(_delta : float) -> void:
	if axis_grabbed != 0:
		var cam = get_viewport().get_camera_3d()
		var mousepos = get_viewport().get_mouse_position()

		var origin = cam.project_ray_origin(mousepos)
		var end = origin + cam.project_ray_normal(mousepos) * RAY_LENGTH
		var query = PhysicsRayQueryParameters3D.create(origin, end)
		var space_state = get_world_3d().direct_space_state
		query.collide_with_areas = true
		var global_pos = space_state.intersect_ray(query)["position"]
		
		if pos.visible:
			if global_pos != null:
				match axis_grabbed:
					1:
						global_pos = Vector3(clamp(snapped(global_pos.x - 0.5, snapping), -pos_cap_x, pos_cap_x), position.y, position.z)
					2:
						global_pos = Vector3(position.x, clamp(snapped(global_pos.y - 0.5, snapping), -pos_cap_y, pos_cap_y), position.z)
					3:
						global_pos = Vector3(position.x, position.y, clamp(snapped(global_pos.z - 0.5, snapping), -pos_cap_z, pos_cap_z))
				
				pos_changed.emit(global_pos)
		elif size.visible:
			if global_pos != null:
				match axis_grabbed:
					1:
						global_pos = Vector3(clamp(snapped((global_pos.x - position.x) * 2, snapping), snapping, size_cap_x), size_y_mesh.position.y * 2, size_z_mesh.position.z * 2)
					2:
						global_pos = Vector3(size_x_mesh.position.x * 2, clamp(snapped((global_pos.y - position.y) * 2, snapping), snapping, size_cap_y), size_z_mesh.position.z * 2)
					3:
						global_pos = Vector3(size_x_mesh.position.x * 2, size_y_mesh.position.y * 2, clamp(snapped((global_pos.z - position.z) * 2, snapping), snapping, size_cap_z))
				size_changed.emit(global_pos)
		elif rot.visible:
			var holder = 0
			if global_pos != null:
				match axis_grabbed:
					1:
						holder = snapped((global_pos.z - position.z) * 50, 1)
						global_pos = Vector3(holder - prev_rotation, 0, 0)
					2:
						holder = snapped(-(global_pos.x + global_pos.z - position.x - position.z) * 50, 1)
						global_pos = Vector3(0, holder - prev_rotation, 0)
					3:
						holder = -snapped((global_pos.x - position.x) * 50, 1)
						global_pos = Vector3(0, 0, holder - prev_rotation)
						
				prev_rotation = holder
				if global_pos != Vector3.ZERO:
					rot_changed.emit(global_pos)

func selected_pos_changed(new_pos : Vector3) -> void:
	position = new_pos
	size_cap_x = clamp(MAX_SIZE - 2 * abs(new_pos.x), 1, MAX_SIZE)
	size_cap_y = clamp(MAX_SIZE - 2 * abs(new_pos.y), 1, MAX_SIZE)
	size_cap_z = clamp(MAX_SIZE - 2 * abs(new_pos.z), 1, MAX_SIZE)

func selected_size_changed(new_size : Vector3) -> void:
	size_x_mesh.position.x = new_size.x / 2
	size_y_mesh.position.y = new_size.y / 2
	size_z_mesh.position.z = new_size.z / 2
	pos_cap_x = clamp(MAX_POS - new_size.x / 2, 0, MAX_POS - 0.5)
	pos_cap_y = clamp(MAX_POS - new_size.y / 2, 0, MAX_POS - 0.5)
	pos_cap_z = clamp(MAX_POS - new_size.z / 2, 0, MAX_POS - 0.5)

func selected_rotation_changed(new_rot : Vector3) -> void:
	if rot_proxy.rotation != new_rot:
		rot_proxy.rotation = new_rot
		rot_x_mesh.rotation.x = deg_to_rad(new_rot.x)
		rot_y_mesh.rotation.y = deg_to_rad(new_rot.y - 45)
		rot_z_mesh.rotation.z = deg_to_rad(new_rot.z)

func grabbed(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int, default_size : Vector3, axis : int, mesh : MeshInstance3D, collider : CollisionShape3D):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_action_released("editor_grab"):
				axis_grabbed = 0
				collider.shape.size = default_size
				mesh.mesh.material.albedo_color = default_color[axis - 1]
			else:
				axis_grabbed = axis
				var desired_size = Vector3(0.25,20,0.25)
				if default_size.x != 0.25:
					desired_size.x = 20
				if default_size.z != 0.25:
					desired_size.z = 20
				
				if rot.visible:
					prev_rotation = 0
					if axis == 2:
						desired_size.y = 0.25
				
				collider.shape.size = desired_size
				mesh.mesh.material.albedo_color = selected_color[axis - 1]
