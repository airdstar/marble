extends Node

func play_music(_audio_to_play : String) -> void:
	pass

func play_global(_audio_to_play : String) -> void:
	pass

func play_positional(_audio_to_play : String, _pos : Vector3) -> void:
	pass

func play_sfx(audio_path : String) -> void:
	var audio = AudioStreamPlayer.new()
	audio.stream = ResourceLoader.load(audio_path)
	add_child(audio)
	audio.finished.connect(free_audio.bind(audio))
	audio.play()

func free_audio(audio_player : AudioStreamPlayer) -> void:
	audio_player.queue_free()
