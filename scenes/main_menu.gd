extends Control


func _on_play_pressed() -> void:
	#get_tree().change_scene_to_file("") #TODO: Colocar la ruta de la escena principal de Arcade.
	pass # Replace with function body.


func _on_settings_pressed() -> void:
	$Settings.show()


func _on_credits_pressed() -> void:
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()
