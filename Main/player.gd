extends RigidBody3D
class_name player

@onready var emittedLight = $OmniLight3D
@onready var collision := $Area3D
@onready var raycast := $RayCast3D

var on_ground : bool = false

func _ready():
	$MeshInstance3D.mesh.material.albedo_color = PlayerInfo.player_data.player_color
	emittedLight.light_color = PlayerInfo.player_data.player_color

func _physics_process(_delta: float) -> void:
	raycast.global_rotation = Vector3.ZERO
	if raycast.is_colliding():
		on_ground = true
	else:
		on_ground = false

func enable_monitoring() -> void:
	collision.set_deferred("monitorable", true)
