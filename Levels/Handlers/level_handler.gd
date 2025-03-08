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
	else:
		if master.in_order:
			current_level = level_pool[level_num]
		else:
			current_level = level_pool.pick_random()

func generate_level(delay : bool) -> void:
	pick_level()
	if current_level != null:
		if delay:
			if master.prev_instance != null:
				await get_tree().create_timer(0.4).timeout
				master.prev_instance.queue_free()
				master.prev_instance = null
		
		var instanced_level := current_level.associated_scene.instantiate()

		master.instanced = instanced_level
		master.origin.add_child(instanced_level)
		
		level_generated.emit(current_level)
