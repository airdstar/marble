extends Node

var currentScene
var loadingScreen
var settings

func _ready():
	Global.main = self
	settings = preload("res://Main/SettingsMenu.tscn").instantiate()
	add_child(settings)
	settings.visible = false
	main_menu()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("pause"):
		if !RunInfo.inRun:
			if settings.visible == true:
				settings.visible = false
				if Global.runBase == null:
					get_tree().paused = false
			else:
				settings.visible = true
				get_tree().paused = true
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func main_menu():
	if currentScene != null:
		currentScene.queue_free()
	currentScene = preload("res://Main/RunStarter.tscn").instantiate()
	add_child(currentScene)

func start_run():
	if currentScene != null:
		currentScene.queue_free()
	currentScene = preload("res://Levels/Handlers/Floor.tscn").instantiate()
	Global.runBase = currentScene
	add_child(currentScene)
