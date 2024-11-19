extends RigidBody3D

@onready var emittedLight = $OmniLight3D

func _ready():
	emittedLight.light_color = RunInfo.playerColor
