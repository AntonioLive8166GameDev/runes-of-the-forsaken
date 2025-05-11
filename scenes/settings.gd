extends Control


func _ready() -> void:
	hide()
	load_settings()


func load_settings() -> void:
	AudioServer.set_bus_mute(1, SETTINGS.settings.music_muted)
	$Panel/VBoxContainer/Music.button_pressed = not SETTINGS.settings.music_muted
	AudioServer.set_bus_mute(2, SETTINGS.settings.sfx_muted)
	$Panel/VBoxContainer/SFX.button_pressed = not SETTINGS.settings.sfx_muted
	
	match SETTINGS.settings.language:
		"es_MX":
			$Panel/VBoxContainer/LanguagePopup.select(0)
			TranslationServer.set_locale("es")
		"en_US":
			$Panel/VBoxContainer/LanguagePopup.select(1)
			TranslationServer.set_locale("en")


func _on_music_toggled(toggled_on: bool) -> void:
	if toggled_on:
		AudioServer.set_bus_mute(1, false)
		SETTINGS.settings.music_muted = false
	else:
		AudioServer.set_bus_mute(1, true)
		SETTINGS.settings.music_muted = true
	
	SETTINGS.save_file()


func _on_sfx_toggled(toggled_on: bool) -> void:
	if toggled_on:
		AudioServer.set_bus_mute(2, false)
		SETTINGS.settings.sfx_muted = false
	else:
		AudioServer.set_bus_mute(2, true)
		SETTINGS.settings.sfx_muted = true
	
	SETTINGS.save_file()


func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			TranslationServer.set_locale("es")
			SETTINGS.settings.language = "es_MX"
		1:
			TranslationServer.set_locale("en")
			SETTINGS.settings.language = "en_US"
	
	SETTINGS.save_file()


func _on_close_pressed() -> void:
	hide()
