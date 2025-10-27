extends Node
class_name level

@export var parts : Array[part]
@export var starts : Array[Node]

@export var input_node : Area3D
@export var input_collider : CollisionShape3D

func open_editor():
	input_collider.disabled = true
	for n : part in parts:
		if n.collider != null:
			n.collider.disabled = true
		if n.editor_visibility != null:
			n.editor_visibility.visible = true

func start_level() -> void:
	input_collider.disabled = false
	for n : Node in parts:
		for m in n.get_children():
			if m is rotateable_component:
				m.level_loaded()
			
		if n.collider != null:
			n.collider.disabled = false
		if n.editor_visibility != null:
			n.editor_visibility.visible = false



func choose_spawn() -> Vector3:
	var holder = []
	for n in starts:
		holder.append(Vector2(n.position.x, n.position.z))
	if holder.size() == 0:
		holder.append(Vector2.ZERO)
	var chosen_spawn = holder.pick_random()
	input_collider.position = Vector3(chosen_spawn.x, 10, chosen_spawn.y)
	return Vector3(chosen_spawn.x, 20, chosen_spawn.y)

func input_trigger(area: Area3D) -> void:
	if area.get_parent() is Player:
		Game.scene.allow_input = true
