extends Node
class_name level

@export var parts : Array[Node3D]

@export var geometry : Node3D
@export var start_node : Area3D


var start

signal timer_start

func _ready():
	pass

func open_editor():
	$InputTrigger.visible = false
	for n : Node3D in parts:
		if "collider" in n:
			n.collider.disabled = true

func start_level():
	start = $Starts/Area3D
	self.freeze = true
	start.area_entered.connect(start_timer)
	choose_spawn()

func choose_spawn():
	var holder = []
	for n in start.get_children():
		holder.append(Vector2(n.position.x, n.position.z))
	Global.runBase.chosenSpawn = holder.pick_random()

func input_trigger(area: Area3D) -> void:
	if area.get_parent() is player:
		Global.runBase.allow_input = true

func start_timer(area : Area3D) -> void:
	if area.get_parent() is player:
		start.set_deferred("monitoring", false)
		timer_start.emit()

func reset_state() -> void:
	await get_tree().create_timer(0.7).timeout
	start.set_deferred("monitoring", true)
