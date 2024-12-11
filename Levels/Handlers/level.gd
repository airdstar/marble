extends Node
class_name level

@onready var start = $Starts/Area3D

func _ready():
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

func start_timer(_area : Area3D) -> void:
	start.set_deferred("monitoring", false)
	Global.runBase.start_timer()

func reset_state() -> void:
	await get_tree().create_timer(0.7).timeout
	start.set_deferred("monitoring", true)
