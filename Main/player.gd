extends RigidBody3D
class_name player

@onready var emittedLight = $OmniLight3D
@onready var collision := $Area3D
@onready var raycast := $RayCast3D

func _ready():
	$MeshInstance3D.mesh.material.albedo_color = PlayerInfo.player_data.player_color
	emittedLight.light_color = PlayerInfo.player_data.player_color

func _physics_process(delta: float) -> void:
	raycast.rotation = raycast.rotation - rotation
	if raycast.is_colliding():
		print("herroooo")

func enable_monitoring() -> void:
	collision.set_deferred("monitorable", true)
