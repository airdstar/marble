extends component
class_name rotateable_component

@export var to_rotate : Node3D

@export_category("Rotation")
## Rotation from start (in degrees), make negative if desired direction is counterclockwisey
@export var rotation_amount : float = 360
## Time to complete a rotation (in seconds)
@export var rotation_speed : float = 5
## Time interval between rotations (in seconds), must be at least 0.01 or tweens will overlap
@export var downtime : float = 0.01

@export_category("Direction")
## Should it rotate back to previous position?
@export var reversable : bool = false
## Should the desired direction be random?
@export var random_direction : bool = false

func level_loaded():
	rotation_amount = deg_to_rad(rotation_amount)
	if random_direction:
		if randi_range(0,1) == 1:
			rotation_amount = -rotation_amount
	
	rotate_object()

func rotate_object():
	var tween
	while(true):
		tween = create_tween()
		tween.tween_property(to_rotate, "rotation", Vector3(to_rotate.rotation.x, to_rotate.rotation.y - rotation_amount,to_rotate.rotation.z), rotation_speed)
		await get_tree().create_timer(rotation_speed + downtime).timeout
		if reversable:
			tween = create_tween()
			tween.tween_property(to_rotate, "rotation", Vector3(to_rotate.rotation.x, to_rotate.rotation.y + rotation_amount,to_rotate.rotation.z), rotation_speed)
			await get_tree().create_timer(rotation_speed + downtime).timeout
