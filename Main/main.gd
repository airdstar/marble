extends Node

var currentScene
var loadingScreen
var settings

func _ready() -> void:
	Global.main = self
	settings = preload("res://Main/SettingsMenu.tscn").instantiate()
	add_child(settings)
	settings.visible = false
	main_menu()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("exit"):
		PlayerInfo.save_info()
		get_tree().quit()

func main_menu() -> void:
	if currentScene != null:
		currentScene.queue_free()
	currentScene = preload("res://Main/MainMenu.tscn").instantiate()
	add_child(currentScene)

func start_run() -> void:
	if currentScene != null:
		currentScene.queue_free()
	currentScene = preload("res://Levels/Handlers/PlayFloor.tscn").instantiate()
	add_child(currentScene)

func open_gallery() -> void:
	if currentScene != null:
		currentScene.queue_free()
	currentScene = preload("res://Main/Gallery.tscn").instantiate()
	add_child(currentScene)

func start_gallery(level_info : level_resource) -> void:
	if currentScene != null:
		currentScene.queue_free()
	currentScene = preload("res://Levels/Handlers/GalleryFloor.tscn").instantiate()
	currentScene.level_info = level_info
	add_child(currentScene)

func open_settings() -> void:
	PlayerInfo.save_info()
	settings.visible = true
	get_tree().paused = true

func close_settings() -> void:
	PlayerInfo.save_info()
	settings.visible = false
	get_tree().paused = false
