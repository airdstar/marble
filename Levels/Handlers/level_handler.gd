extends Node
class_name LevelHandler

@export var master : floor

var current_level : level_resource
var level_pool : Array[level_resource] = []

var level_num := 0

signal level_generated

func set_level_pool(new_level_pool : Array[level_resource]) -> void:
	level_pool = new_level_pool

func pick_level() -> void:
	if level_pool.size() == 0:
		print_stack()
		get_tree().quit()
	if master.in_order:
		current_level = level_pool[level_num]
	else:
		current_level = level_pool.pick_random()

func generate_level(delay : bool) -> void:
	pick_level()
	if delay:
		await get_tree().create_timer(0.4).timeout
		master.prev_instance.queue_free()
	
	var instanced_level := current_level.associated_scene.instantiate()

	master.instanced = instanced_level
	master.origin.add_child(master.instanced)

	if master.allow_timer:
		instanced_level.timer_start.connect(master.start_timer)
	
	level_generated.emit(current_level)
