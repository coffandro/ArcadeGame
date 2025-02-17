extends AudioStreamPlayer

var last_stream = ""

func _on_MusicPlayer_finished():
	play(last_stream)
