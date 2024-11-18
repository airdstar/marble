extends Node

var floor
var transitioning := true
var chosenSpawn : Vector2
var instanced

func start_game():
	floor = get_parent()
	
	create_level()
	floor.timer.set_wait_time(floor.timer.wait_time + instanced.get_meta("GivenTime"))
	floor.origin.add_child(instanced)
	chosenSpawn = instanced.get_meta("StartPos")[randi_range(0, instanced.get_meta("StartPos").size() - 1)]
	
	var rotation = randf_range(instanced.get_meta("PossibleRotations").x,instanced.get_meta("PossibleRotations").y)
	floor.camera.rotation.y = deg_to_rad(rotation)
	floor.background.rotation.y = deg_to_rad(rotation + floor.relative_background_rotation)
	
	floor.player = preload("res://Player.tscn").instantiate()
	floor.add_child(floor.player)
	reset_player()
	
	await get_tree().create_timer(0.7).timeout
	floor.timer.start()
	transitioning = false

func next_level():
	if !transitioning:
		
		transitioning = true
		var holder = instanced
		
		create_level()
		chosenSpawn = instanced.get_meta("StartPos")[randi_range(0, instanced.get_meta("StartPos").size() - 1)]
		floor.timer.set_wait_time(floor.timer.time_left + instanced.get_meta("GivenTime"))
		floor.timer.stop()
		
		var tween = create_tween()
		tween.tween_property(floor.camera, "position", Vector3(0,-281,0), 0.7).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
		
		await get_tree().create_timer(0.3).timeout
		
		holder.queue_free()
		floor.origin.add_child(instanced)
		floor.player.visible = false
		
		var rotation = randf_range(instanced.get_meta("PossibleRotations").x,instanced.get_meta("PossibleRotations").y)
		floor.camera.rotation.y = deg_to_rad(rotation)
		floor.background.rotation.y = deg_to_rad(rotation + floor.relative_background_rotation)

		await get_tree().create_timer(0.41).timeout
		
		floor.camera.position = Vector3(0,355,0)
		tween = create_tween()
		tween.tween_property(floor.camera, "position", Vector3(0,305,0), 0.2).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		await get_tree().create_timer(0.2).timeout
		reset_player()
		floor.player.visible = true
		
		await get_tree().create_timer(0.7).timeout
		
		floor.timer.start()
		transitioning = false

func pick_level():
	var directory : String
	match RunInfo.currentDifficulty:
		0:
			directory = "res://Levels/Easy Levels/"
		1:
			directory = "res://Levels/Medium Levels/"
		2:
			directory = "res://Levels/Hard Levels/"
		3:
			directory = "res://Levels/Test Levels/"
	
	var dir = DirAccess.open(directory)
	dir.list_dir_begin()
	var currentLevel : String = dir.get_next()
	var allLevels : Array[String]
	while currentLevel != "":
		allLevels.append(directory + currentLevel)
		currentLevel = dir.get_next()
	dir.list_dir_end()
	
	return allLevels[randi_range(0, allLevels.size() - 1)]

func create_level():
	var chosenLevel = pick_level()
	var current_platform = load(chosenLevel)
	instanced = current_platform.instantiate()

func reset_player():
	floor.player.linear_velocity = Vector3.ZERO
	floor.player.angular_velocity = Vector3.ZERO
	floor.player.position = Vector3(chosenSpawn.x,315,chosenSpawn.y)

func game_over():
	get_tree().quit()
