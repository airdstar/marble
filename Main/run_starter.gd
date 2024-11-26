extends Node

var allow_test : bool = true

var easy_veto : bool = false
var medium_veto : bool = true
var hard_veto : bool = true

@onready var easy : Button = $Easy
@onready var medium : Button = $Medium
@onready var hard : Button = $Hard
@onready var test : Button = $Test

@onready var red_slider : HSlider = $Red
@onready var blue_slider : HSlider = $Blue
@onready var green_slider : HSlider = $Green

func _ready() -> void:
	red_slider.value = RunInfo.playerColor.r
	blue_slider.value = RunInfo.playerColor.b
	green_slider.value = RunInfo.playerColor.g
	check_valid_difficulties()

func _process(_delta: float) -> void:
	$TextureRect.texture = $SubViewport.get_texture()
	$SubViewport/MeshInstance3D.rotate_y(0.0001)


func check_valid_difficulties() -> void:
	for n in range(4):
		var level_count : int = 0
		var dir : DirAccess = DirAccess.open(Global.level_directories[n])
		if dir != null:
			dir.list_dir_begin()
			var currentLevel : String = dir.get_next()
			while currentLevel != "":
				level_count += 1
				currentLevel = dir.get_next()
			dir.list_dir_end()
		match n:
			0:
				if level_count > 0 and !easy_veto:
					easy.disabled = false
				else:
					easy.disabled = true
			1:
				if level_count > 0 and !medium_veto:
					medium.disabled = false
				else:
					medium.disabled = true
			2:
				if level_count > 0 and !hard_veto:
					hard.disabled = false
				else:
					hard.disabled = true
			3:
				if allow_test:
					if level_count > 0:
						test.disabled = false
					else:
						test.disabled = true
				else:
					test.visible = false


func easy_pressed() -> void:
	RunInfo.currentDifficulty = RunInfo.difficulty.EASY
	Global.main.start_run()

func medium_pressed() -> void:
	RunInfo.currentDifficulty = RunInfo.difficulty.MEDIUM
	Global.main.start_run()

func hard_pressed() -> void:
	RunInfo.currentDifficulty = RunInfo.difficulty.HARD
	Global.main.start_run()

func test_pressed() -> void:
	RunInfo.currentDifficulty = RunInfo.difficulty.TEST
	Global.main.start_run()


func red_changed(value: float) -> void:
	RunInfo.playerColor.r = value
	$SubViewport/MeshInstance3D/OmniLight3D.light_color = RunInfo.playerColor

func blue_changed(value: float) -> void:
	RunInfo.playerColor.b = value
	$SubViewport/MeshInstance3D/OmniLight3D.light_color = RunInfo.playerColor

func green_changed(value: float) -> void:
	RunInfo.playerColor.g = value
	$SubViewport/MeshInstance3D/OmniLight3D.light_color = RunInfo.playerColor
