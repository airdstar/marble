extends RigidBody3D
class_name player

var customization : PlayerCustomization

@export var visible_mesh : MeshInstance3D

@export var front : Decal
@export var back : Decal

@export var light : OmniLight3D
@export var collision : Area3D

var reset_pos : Vector3

signal level_start
signal next_level
signal orientation_change

func _ready():
	set_color()
	set_decal()

func set_customization(player_customization : PlayerCustomization) -> void:
	customization = player_customization

func set_color() -> void:
	visible_mesh.mesh.material.albedo_color = customization.chosen_color.lightened(0.7)
	visible_mesh.mesh.material.next_pass.albedo_color = customization.chosen_color
	light.light_color = customization.chosen_color

func set_decal() -> void:
	if customization.chosen_decal != null:
		%Decal.show()
		%Decal.texture_albedo = customization.chosen_decal
	else:
		%Decal.hide()


func collision_detected(body: Node3D) -> void:
	if body.is_in_group("Goal"):
		next_level.emit()
		collision.set_deferred("monitorable", false)
	elif body.is_in_group("Respawner"):
		orientation_change.emit()
		reset()

func _collision_detected(area: Area3D) -> void:
	if area.is_in_group("Start"):
		level_start.emit()
	elif area.is_in_group("Boost"):
		await get_tree().create_timer(area.delay).timeout
		if collision.overlaps_area(area):
			apply_force(area.transform.basis * area.direction * area.amount * 100 / area.scale)
			_collision_detected(area)

func reset() -> void:
	visible = true
	position = reset_pos
	angular_velocity = Vector3.ZERO
	linear_velocity = Vector3.ZERO
	collision.set_deferred("monitorable", true)
