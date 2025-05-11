extends Node

const FILENAME: String = "user://settings.dat"
var settings = {
	"music_muted" : false,
	"sfx_muted" : false,
	"language" : TranslationServer.get_locale()
}


func _ready() -> void:
	load_file()


func load_file() -> void:
	var file = FileAccess.open(FILENAME, FileAccess.READ)
	if file == null:
		save_file()
	else:
		settings = file.get_var()
	file = null


func save_file() -> void:
	var file = FileAccess.open(FILENAME, FileAccess.WRITE)
	if file != null:
		file.store_var(settings)
	file = null
