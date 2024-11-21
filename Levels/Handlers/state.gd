extends Node

var transitioning := true
var allowInput : bool = true
var chosenSpawn : Vector2
var instanced
var player

func start_game():
	transitioning = true
	RunInfo.inRun = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if instanced != null:
		instanced.queue_free()
	
	if player != null:
		player.queue_free()
	
	create_level()
	Global.runBase.timer.set_wait_time(10 + instanced.get_meta("GivenTime"))
	Global.runBase.origin.add_child(instanced)
	chosenSpawn = instanced.get_meta("StartPos")[randi_range(0, instanced.get_meta("StartPos").size() - 1)]
	
	var rotation = randf_range(instanced.get_meta("PossibleRotations").x,instanced.get_meta("PossibleRotations").y)
	Global.runBase.camera.rotation.y = deg_to_rad(rotation)
	Global.runBase.background.rotation.y = deg_to_rad(rotation)
	
	player = preload("res://Main/Marble.tscn").instantiate()
	Global.runBase.add_child(player)
	reset_player()
	
	await get_tree().create_timer(0.7).timeout
	Global.runBase.timer.start()
	transitioning = false

func next_level():
	transitioning = true
	var holder = instanced
	
	create_level()
	chosenSpawn = instanced.get_meta("StartPos")[randi_range(0, instanced.get_meta("StartPos").size() - 1)]
	Global.runBase.timer.set_wait_time(Global.runBase.timer.time_left + instanced.get_meta("GivenTime"))
	Global.runBase.timer.stop()
	
	var tween = create_tween()
	tween.tween_property(Global.runBase.camera, "position", Vector3(0,-281,0), 0.7).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	
	await get_tree().create_timer(0.3).timeout
	
	holder.queue_free()
	Global.runBase.origin.add_child(instanced)
	player.visible = false
	
	var rotation = randf_range(instanced.get_meta("PossibleRotations").x,instanced.get_meta("PossibleRotations").y)
	Global.runBase.camera.rotation.y = deg_to_rad(rotation)
	Global.runBase.background.rotation.y = deg_to_rad(rotation + Global.runBase.relative_background_rotation)

	await get_tree().create_timer(0.41).timeout
	
	Global.runBase.camera.position = Vector3(0,355,0)
	tween = create_tween()
	tween.tween_property(Global.runBase.camera, "position", Vector3(0,305,0), 0.2).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(0.2).timeout
	reset_player()
	player.visible = true
	
	await get_tree().create_timer(0.7).timeout
	
	Global.runBase.timer.start()
	transitioning = false

func pick_level():
	var dir = DirAccess.open(Global.level_directories[RunInfo.currentDifficulty])
	dir.list_dir_begin()
	var currentLevel : String = dir.get_next()
	var allLevels : Array[String]
	while currentLevel != "":
		if '.tscn.remap' in currentLevel:
			currentLevel = currentLevel.trim_suffix('.remap')
		allLevels.append(Global.level_directories[RunInfo.currentDifficulty] + currentLevel)
		currentLevel = dir.get_next()
	dir.list_dir_end()
	
	return allLevels[randi_range(0, allLevels.size() - 1)]

func create_level():
	var chosenLevel = pick_level()
	var current_platform = load(chosenLevel)
	instanced = current_platform.instantiate()

func reset_player():
	player.linear_velocity = Vector3.ZERO
	player.angular_velocity = Vector3.ZERO
	player.position = Vector3(chosenSpawn.x,315,chosenSpawn.y)

func reset_orientation():
	allowInput = false
	
	var rotationAmount = deg_to_rad(randf_range(instanced.get_meta("PossibleRotations").x,instanced.get_meta("PossibleRotations").y))
	rotationAmount -= deg_to_rad(fmod(rad_to_deg(Global.runBase.camera.rotation.y), 360))
	
	var tween = create_tween()
	tween.tween_property(Global.runBase.camera, "rotation", Global.runBase.camera.rotation + Vector3(0,rotationAmount,0), 1.5).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
	var backgroundTween = create_tween()
	backgroundTween.tween_property(Global.runBase.background, "rotation", Global.runBase.background.rotation + Vector3(0,rotationAmount,0), 1.5).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
	
	await get_tree().create_timer(0.8).timeout
	allowInput = true
