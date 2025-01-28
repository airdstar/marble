extends Node

func play_music(audio_to_play : String) -> void:
    Global.main_scene.music_player.play(Audio.music[audio_to_play])

func play_global(audio_to_play : String) -> void:
    pass

func play_positional(audio_to_play : String, pos : Vector3) -> void:
    pass