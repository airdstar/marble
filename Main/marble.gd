extends RigidBody3D
class_name player

@onready var emittedLight = $OmniLight3D

func _ready():
	$MeshInstance3D.mesh.material.albedo_color = PlayerInfo.player_data.player_color
	emittedLight.light_color = PlayerInfo.player_data.player_color
