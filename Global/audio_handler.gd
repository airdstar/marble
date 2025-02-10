extends Node

func play_music(audio_to_play : String) -> void:
	Global.main_scene.music_player.play(Audio.music[audio_to_play])

func play_global(_audio_to_play : String) -> void:
	pass

func play_positional(_audio_to_play : String, _pos : Vector3) -> void:
	pass
