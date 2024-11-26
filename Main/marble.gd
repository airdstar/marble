extends RigidBody3D
class_name player

@onready var emittedLight = $OmniLight3D

func _ready():
	$MeshInstance3D.mesh.material.albedo_color = RunInfo.playerColor
	emittedLight.light_color = RunInfo.playerColor
