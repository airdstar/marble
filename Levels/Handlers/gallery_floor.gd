extends floor
class_name gallery_floor

func secondary_process() -> void:
	if Input.is_action_just_pressed("back"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Global.main.open_gallery()

func start_game() -> void:
	transitioning = true
	allowInput = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	create_level()
	set_level_data()
	change_skybox_rotation()
	RunInfo.inRun = true
	
	if marble == null:
		var holder = preload("res://Main/Marble.tscn").instantiate()
		add_child(holder)
		marble = holder
	
	call_deferred("reset_marble")
	
	await get_tree().create_timer(0.5).timeout
	allowInput = true

func next_level() -> void:
	transitioning = true
	marble.visible = false
	instanced.reset_state()

	camera.next_level()
	change_skybox_rotation()
	
	await get_tree().create_timer(0.6).timeout
	
	var rot = randf_range(level_info.possible_rotations.x,level_info.possible_rotations.y)
	camera.rotation.y = deg_to_rad(rot)
	camera.skybox.sky_rotation = Vector3(0, deg_to_rad(rot), 0) + relative_skybox_rotation
	
	await get_tree().create_timer(0.3).timeout
	
	allowInput = false
	reset_marble()
	marble.visible = true
	
	await get_tree().create_timer(0.5).timeout
	allowInput = true

func set_level_data() -> void:
	$CanvasLayer/tagline.text = level_info.tagline
	
	var rot = randf_range(level_info.possible_rotations.x,level_info.possible_rotations.y)
	camera.rotation.y = deg_to_rad(rot)
	camera.skybox.sky_rotation = Vector3(0, deg_to_rad(rot), 0) + relative_skybox_rotation
	
	origin.add_child(instanced)

func pick_level() -> void:
	pass
