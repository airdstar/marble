extends Node3D

@export var rotation_amount : float = 360
@export var rotation_speed : float = 5
@export var downtime : float = 0.01

@export_category("Direction")
@export var reversable : bool = false
@export var random_direction : bool = false

func _ready():
	self.freeze = true
	$MeshInstance3D.create_trimesh_collision()
	
	if random_direction:
		if randi_range(0,1) == 1:
			rotation_amount = -rotation_amount
	
	rotate_object()

func rotate_object():
	var tween
	while(true):
		tween = create_tween()
		tween.tween_property(self, "rotation", Vector3(0,self.rotation.y - deg_to_rad(rotation_amount),0), rotation_speed)
		await get_tree().create_timer(rotation_speed + downtime).timeout
		if reversable:
			tween = create_tween()
			tween.tween_property(self, "rotation", Vector3(0,self.rotation.y + deg_to_rad(rotation_amount),0), rotation_speed)
			await get_tree().create_timer(rotation_speed + downtime).timeout
