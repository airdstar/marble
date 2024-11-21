extends Node


var allow_test : bool = true

var easy_veto : bool = false
var medium_veto : bool = true
var hard_veto : bool = true

@onready var easy = $Easy
@onready var medium = $Medium
@onready var hard = $Hard
@onready var test = $Test

func _ready():
	$ColorPickerButton.color = RunInfo.playerColor
	check_valid_difficulties()

func color_changed(color: Color) -> void:
	RunInfo.playerColor = color

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

func check_valid_difficulties():
	for n in range(4):
		var dir = DirAccess.open(Global.level_directories[n])
		dir.list_dir_begin()
		var currentLevel : String = dir.get_next()
		var level_count : int = 0
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
