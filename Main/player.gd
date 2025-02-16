extends RigidBody3D
class_name player

var customization : PlayerCustomization

@export var visible_mesh : MeshInstance3D

@export var face : Decal
@export var flair : Decal

@export var light : OmniLight3D
@export var collision : Area3D

func _ready():
	set_color()
	set_face()
	set_flair()

func set_customization(player_customization : PlayerCustomization) -> void:
	customization = player_customization

func set_color() -> void:
	
	visible_mesh.mesh.material.albedo_color = customization.chosen_color.lightened(1)
	visible_mesh.mesh.material.next_pass.albedo_color = customization.chosen_color
	light.light_color = customization.chosen_color

func set_face() -> void:
	face.texture_albedo = customization.chosen_face

func set_flair() -> void:
	flair.texture_albedo = customization.chosen_flair

func enable_monitoring() -> void:
	collision.set_deferred("monitorable", true)
