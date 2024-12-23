extends Control

func _ready():
	Update()

func Update():
	var has_conection = OS.execute("./FetchConnectionStatus.sh", [], true)
	
	if has_conection == 0:
		print("Connected to Github")
		var is_out_of_date = OS.execute("./FetchUpdateVersion.sh", [], true)
		
		if is_out_of_date == 1:
			print("Game is out of date, updating")
			var did_update_succeed = OS.execute("./UpdateTheGame.sh", [], true)
			
			if did_update_succeed == 1:
				print("Game failed to update")
				emit_signal("done_updating")
			else:
				print("Game is now updated, reloading game")
				OS.execute("./ReloadGame.sh", [], false)
				get_tree().quit()
				return
		else:
			print("Game is up to date")
	else:
		print("Not connected to Github, cannot check")
	
	get_tree().change_scene("res://Main.tscn")
	
