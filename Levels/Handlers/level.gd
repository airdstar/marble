extends Node
class_name level

@export var parts : Array[Node3D]

@export var start_node : Area3D

@export var input_node : Area3D
@export var input_collider : CollisionShape3D


signal timer_start

func _ready():
	pass

func open_editor():
	input_collider.disabled = true
	for n : Node3D in parts:
		if "collider" in n:
			n.collider.disabled = true
		if "editor_visibility" in n:
			n.visible = true

func start_level():
	input_collider.disabled = false
	for n : Node3D in parts:
		for m in n.get_children():
			if m is rotateable_component:
				m.level_loaded()
		if "collider" in n:
			n.collider.disabled = false
		if "editor_visibility" in n:
			n.editor_visibility.visible = false
	choose_spawn()

func choose_spawn():
	var holder = []
	for n in start_node.get_children():
		holder.append(Vector2(n.position.x, n.position.z))
	if holder.size() == 0:
		holder.append(Vector2.ZERO)
	var chosen_spawn = holder.pick_random()
	input_collider.position = Vector3(chosen_spawn.x, 10, chosen_spawn.y)
	Global.current_scene.chosenSpawn = chosen_spawn

func input_trigger(area: Area3D) -> void:
	if area.get_parent() is player:
		Global.current_scene.allow_input = true

func start_timer(area : Area3D) -> void:
	if area.get_parent() is player:
		start_node.set_deferred("monitoring", false)
		timer_start.emit()

func reset_state() -> void:
	await get_tree().create_timer(0.7).timeout
	start_node.set_deferred("monitoring", true)
