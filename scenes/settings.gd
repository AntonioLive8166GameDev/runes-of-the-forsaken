extends Control


func _ready() -> void:
	hide()
	load_settings()


## Carga los ajustes guardados con el singletone SETTINGS.
func load_settings() -> void:
	# Música y SFX.
	AudioServer.set_bus_mute(1, SETTINGS.settings.music_muted)
	$Panel/VBoxContainer/Music.button_pressed = not SETTINGS.settings.music_muted
	AudioServer.set_bus_mute(2, SETTINGS.settings.sfx_muted)
	$Panel/VBoxContainer/SFX.button_pressed = not SETTINGS.settings.sfx_muted
	
	# Idioma.
	match SETTINGS.settings.language:
		"es", "es_MX":
			$Panel/VBoxContainer/LanguagePopup.select(0)
			TranslationServer.set_locale("es")
		"en", "en_US":
			$Panel/VBoxContainer/LanguagePopup.select(1)
			TranslationServer.set_locale("en")


## Interruptor de música.
func _on_music_toggled(toggled_on: bool) -> void:
	if toggled_on:
		AudioServer.set_bus_mute(1, false)
		SETTINGS.settings.music_muted = false
	else:
		AudioServer.set_bus_mute(1, true)
		SETTINGS.settings.music_muted = true
	
	SETTINGS.save_settings()


## Interruptor de efectos de sonido.
func _on_sfx_toggled(toggled_on: bool) -> void:
	if toggled_on:
		AudioServer.set_bus_mute(2, false)
		SETTINGS.settings.sfx_muted = false
	else:
		AudioServer.set_bus_mute(2, true)
		SETTINGS.settings.sfx_muted = true
	
	SETTINGS.save_settings()


## Opción de idioma.
func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			TranslationServer.set_locale("es")
			SETTINGS.settings.language = "es"
		1:
			TranslationServer.set_locale("en")
			SETTINGS.settings.language = "en"
	
	SETTINGS.save_settings()


func _on_close_pressed() -> void:
	hide()


func _play_pressed_sfx(_toggled_on: bool) -> void:
	GlobalSounds.get_node("SFX").stream = preload("res://resourses/sfx/selection.wav")
	GlobalSounds.get_node("SFX").play()


func _play_hover_sfx(_index: int) -> void:
	GlobalSounds.get_node("SFX").stream = preload("res://resourses/sfx/confirm_selection.wav")
	GlobalSounds.get_node("SFX").play()
