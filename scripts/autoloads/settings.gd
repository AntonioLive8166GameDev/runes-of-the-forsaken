extends Node
## Save system for settings.

## File path
const FILENAME: String = "user://settings.dat"
var settings = {
	"music_muted" : false, 
	"sfx_muted" : false,
	"language" : TranslationServer.get_locale()
}


func _ready() -> void:
	load_settings()

## Sets [param settings] with the sotored data.
func load_settings() -> void:
	var file = FileAccess.open(FILENAME, FileAccess.READ)
	if file == null:
		save_settings()
	else:
		settings = file.get_var()
	file = null


## Stores [param settings] in a file in [constant SETTINGS.FILENAME].
func save_settings() -> void:
	var file = FileAccess.open(FILENAME, FileAccess.WRITE)
	if file != null:
		file.store_var(settings)
	file = null
