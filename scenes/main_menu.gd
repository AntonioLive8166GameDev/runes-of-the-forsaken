extends Control


func _on_play_pressed() -> void:
	#get_tree().change_scene_to_file("") #TODO: Colocar la ruta de la escena principal de Arcade.
	pass


func _on_settings_pressed() -> void:
	$Settings.show()


func _on_credits_pressed() -> void:
	pass


func _on_exit_pressed() -> void:
	get_tree().quit()


func _play_hover_sfx() -> void:
	GlobalSounds.get_node("SFX").stream = preload("res://resourses/sfx/confirm_selection.wav")
	GlobalSounds.get_node("SFX").play()

func _play_pressed_sfx() -> void:
	GlobalSounds.get_node("SFX").stream = preload("res://resourses/sfx/selection.wav")
	GlobalSounds.get_node("SFX").play()
