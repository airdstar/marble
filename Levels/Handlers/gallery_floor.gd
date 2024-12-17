extends floor
class_name gallery_floor

func secondary_process() -> void:
	if Input.is_action_just_pressed("back"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Global.main.open_gallery()

func start_game() -> void:
	transitioning = true
	allow_input = false
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

func next_level() -> void:
	transitioning = true
	marble.visible = false
	instanced.reset_state()
	instanced.choose_spawn()

	camera.next_level()
	change_skybox_rotation()
	
	await get_tree().create_timer(0.6).timeout
	
	default_camera_skybox()
	
	await get_tree().create_timer(0.3).timeout
	
	allow_input = false
	reset_marble()

func set_level_data() -> void:
	$CanvasLayer/VBoxContainer/tagline.text = level_info.tagline
	
	default_camera_skybox()
	
	origin.add_child(instanced)

func pick_level() -> void:
	pass
