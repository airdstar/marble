extends Node
class_name level

@export var starts : Array[int]
@export var goals : Array[int]
@export var proc_mesh : Array[ProcMesh]

@onready var geometry := $Geometry

var start

signal timer_start

func _ready():
	pass

func open_editor():
	$InputTrigger.visible = false

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
