extends Node

var transitioning := true
var allowInput : bool = true
var chosenSpawn : Vector2
var instanced
var prev_instance
var player

func start_game():
	transitioning = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if instanced != null:
		instanced.queue_free()
	
	if player != null:
		player.queue_free()
	
	create_level()
	set_level_data()
	RunInfo.inRun = true
	
	player = preload("res://Main/Marble.tscn").instantiate()
	Global.runBase.add_child(player)
	reset_player()
	
	await get_tree().create_timer(0.7).timeout
	Global.runBase.timer.start()
	transitioning = false

func next_level():
	transitioning = true
	prev_instance = instanced
	create_level()
	set_level_data()
	
	var tween = create_tween()
	tween.tween_property(Global.runBase.camera, "position", Vector3(0,-281,0), 0.7).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	
	await get_tree().create_timer(0.71).timeout
	
	Global.runBase.camera.position = Vector3(0,355,0)
	tween = create_tween()
	tween.tween_property(Global.runBase.camera, "position", Vector3(0,305,0), 0.2).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	
	await get_tree().create_timer(0.21).timeout
	reset_player()
	player.visible = true
	
	await get_tree().create_timer(0.7).timeout
	
	
	Global.runBase.timer.start()
	transitioning = false

func set_level_data():
	chosenSpawn = instanced.start_pos[randi_range(0, instanced.start_pos.size() - 1)]
	
	if RunInfo.inRun:
		Global.runBase.timer.set_wait_time(Global.runBase.timer.time_left + instanced.given_time)
	else:
		Global.runBase.timer.set_wait_time(Global.runBase.timer.wait_time + instanced.given_time)
	
	
	
	Global.runBase.timer.stop()
	
	if RunInfo.inRun:
		await get_tree().create_timer(0.3).timeout
		prev_instance.queue_free()
		player.visible = false
		var rotation = randf_range(instanced.possible_rotations.x,instanced.possible_rotations.y)
		Global.runBase.camera.rotation.y = deg_to_rad(rotation)
		Global.runBase.background.rotation.y = deg_to_rad(rotation + Global.runBase.relative_background_rotation)
	else:
		var rotation = randf_range(instanced.possible_rotations.x,instanced.possible_rotations.y)
		Global.runBase.camera.rotation.y = deg_to_rad(rotation)
		Global.runBase.background.rotation.y = deg_to_rad(rotation + Global.runBase.relative_background_rotation)
	
	Global.runBase.origin.add_child(instanced)
	

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
	
	var rotationAmount = deg_to_rad(randf_range(instanced.possible_rotations.x,instanced.possible_rotations.y))
	rotationAmount -= deg_to_rad(fmod(rad_to_deg(Global.runBase.camera.rotation.y), 360))
	
	var tween = create_tween()
	tween.tween_property(Global.runBase.camera, "rotation", Global.runBase.camera.rotation + Vector3(0,rotationAmount,0), 1.5).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
	var backgroundTween = create_tween()
	backgroundTween.tween_property(Global.runBase.background, "rotation", Global.runBase.background.rotation + Vector3(0,rotationAmount,0), 1.5).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
	
	await get_tree().create_timer(0.8).timeout
	allowInput = true
