extends RigidBody3D
class_name player

@export var visible_mesh : MeshInstance3D

@export var face : Decal
@export var marking : Decal

@export var light : OmniLight3D
@export var collision : Area3D


func _ready():
	set_color()
	set_face()
	set_marking()

func set_color() -> void:
	visible_mesh.mesh.material.albedo_color = PlayerInfo.player_data.player_customization.chosen_color.lightened(0.3)
	visible_mesh.mesh.material.next_pass.albedo_color = PlayerInfo.player_data.player_customization.chosen_color
	light.light_color = PlayerInfo.player_data.player_customization.chosen_color

func set_face() -> void:
	if FileAccess.file_exists("res://Assets/Customization/Faces/" + PlayerInfo.player_data.player_customization.chosen_face):
		face.texture_albedo = ResourceLoader.load("res://Assets/Customization/Faces/" + PlayerInfo.player_data.player_customization.chosen_face)
	else:
		face.texture_albedo = ResourceLoader.load("res://Assets/Customization/Faces/1.png")
		PlayerInfo.player_data.player_customization.chosen_face = "1.png"

func set_marking() -> void:
	if FileAccess.file_exists("res://Assets/Customization/Markings/" + PlayerInfo.player_data.player_customization.chosen_marking):
		marking.texture_albedo = ResourceLoader.load("res://Assets/Customization/Markings/" + PlayerInfo.player_data.player_customization.chosen_marking)
	else:
		marking.texture_albedo = ResourceLoader.load("res://Assets/Customization/Markings/1.png")
		PlayerInfo.player_data.player_customization.chosen_marking = "1.png"

func enable_monitoring() -> void:
	collision.set_deferred("monitorable", true)
