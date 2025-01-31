extends RigidBody3D
class_name player

@onready var emittedLight = $OmniLight3D
@onready var collision := $Area3D
@onready var raycast := $RayCast3D

func _ready():
	$MeshInstance3D.mesh.material.albedo_color = PlayerInfo.player_data.player_customization.chosen_color
	$MeshInstance3D.mesh.material.next_pass.albedo_color = PlayerInfo.player_data.player_customization.chosen_color
	$MeshInstance3D.mesh.material.next_pass.albedo_color.a = 0.3
	emittedLight.light_color = PlayerInfo.player_data.player_customization.chosen_color

func _physics_process(delta: float) -> void:
	raycast.global_rotation = Vector3.ZERO
	if raycast.is_colliding():
		apply_force(Vector3(0, 1, 0) * 6000 * delta)

func enable_monitoring() -> void:
	collision.set_deferred("monitorable", true)
