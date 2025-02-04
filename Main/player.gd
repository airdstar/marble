extends RigidBody3D
class_name player

@onready var emittedLight = $OmniLight3D
@onready var collision := $Area3D
@onready var raycast := $RayCast3D

@onready var face := $MeshInstance3D/Face
@onready var marking := $MeshInstance3D/Marking

func _ready():
	set_color()
	set_face()
	set_marking()

func _physics_process(delta: float) -> void:
	raycast.global_rotation = Vector3.ZERO
	if raycast.is_colliding():
		apply_force(Vector3(0, 1, 0) * 6000 * delta)

func set_color() -> void:
	$MeshInstance3D.mesh.material.albedo_color = PlayerInfo.player_data.player_customization.chosen_color
	$MeshInstance3D.mesh.material.next_pass.albedo_color = PlayerInfo.player_data.player_customization.chosen_color
	#$MeshInstance3D.mesh.material.next_pass.albedo_color.a = 0.7
	emittedLight.light_color = PlayerInfo.player_data.player_customization.chosen_color

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
