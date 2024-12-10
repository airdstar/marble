extends Node

enum difficulty {
	EASY,
	MEDIUM,
	HARD
}

var inRun : bool = false

var current_difficulty : difficulty = difficulty.EASY
var current_level : int = 1
