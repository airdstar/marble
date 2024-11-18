extends Node3D

@export var size : Vector3 = Vector3(1,1,1)

## Time for a full rotation
@export var rotateSpeed : float = 5
@export var clockwise : bool = true

func _ready():
	$MeshInstance3D.mesh.size = size
	$MeshInstance3D.create_trimesh_collision()
	rotate_object()

func rotate_object():
	while(true):
		var tween = create_tween()
		if clockwise:
			tween.tween_property(self, "rotation", Vector3(0,deg_to_rad(-360),0), rotateSpeed)
		else:
			tween.tween_property(self, "rotation", Vector3(0,deg_to_rad(360),0), rotateSpeed)
		
		await get_tree().create_timer(rotateSpeed + 0.01).timeout
		rotation = Vector3(0,0,0)
