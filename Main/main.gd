extends Node

var currentScene
var loadingScreen

func _ready() -> void:
	Global.main = self
	main_menu()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()

func main_menu() -> void:
	clear_scene()
	currentScene = preload("res://Main/MainMenu.tscn").instantiate()
	add_child(currentScene)

func start_run() -> void:
	clear_scene()
	currentScene = preload("res://Levels/Handlers/PlayFloor.tscn").instantiate()
	add_child(currentScene)

func open_gallery() -> void:
	RunInfo.inRun = false
	clear_scene()
	currentScene = preload("res://Main/Gallery.tscn").instantiate()
	add_child(currentScene)

func start_gallery(level_info : level_resource) -> void:
	clear_scene()
	currentScene = preload("res://Levels/Handlers/GalleryFloor.tscn").instantiate()
	currentScene.level_info = level_info
	add_child(currentScene)

func open_editor() -> void:
	clear_scene()
	currentScene = preload("res://Levels/Editor/LevelEditor.tscn").instantiate()
	add_child(currentScene)



func clear_scene() -> void:
	if currentScene != null:
		currentScene.queue_free()
