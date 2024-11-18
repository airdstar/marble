extends Node

var currentScene
var loadingScreen
var settings

func _ready():
	Global.main = self
	main_menu()
	settings = preload("res://Main/SettingsMenu.tscn").instantiate()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("pause"):
		if !RunInfo.inRun:
			if get_children().has(settings):
				remove_child(settings)
				get_tree().paused = false
			else:
				add_child(settings)
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
	currentScene = preload("res://Main/Floor.tscn").instantiate()
	Global.runBase = currentScene
	add_child(currentScene)
