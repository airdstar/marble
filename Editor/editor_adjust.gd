extends Node3D

enum adjust_type {
	NOTHING,
	POS,
	SIZE
}

var current_adjustment : adjust_type = adjust_type.NOTHING

@onready var pos := $Position
@onready var size := $Size

@onready var pos_x
@onready var pos_y
@onready var pos_z

@onready var size_x
@onready var size_y
@onready var size_z

var snapping := 0.5

var axis_grabbed : int = 0
const RAY_LENGTH := 40

signal pos_changed
signal size_changed

func _ready() -> void:
	pass

func _process(_delta : float) -> void:
	match current_adjustment:
		adjust_type.POS:
			if axis_grabbed != 0:
				var global_pos = get_mouse_world_position()
				if global_pos != null:
					match axis_grabbed:
						1:
							global_pos = Vector3(snapped(global_pos.x - 0.5, snapping), position.y, position.z)
						2:
							global_pos = Vector3(position.x, snapped(global_pos.y - 0.5, snapping), position.z)
						3:
							global_pos = Vector3(position.x, position.y, snapped(global_pos.z - 0.5, snapping))
					pos_changed.emit(global_pos)
		adjust_type.SIZE:
			pass
		

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


func adjust_pos() -> void:
	current_adjustment = adjust_type.POS
	pos.visible = true
	
	size.visible = false

func adjust_size() -> void:
	current_adjustment = adjust_type.SIZE
	size.visible = true
	
	pos.visible = false
