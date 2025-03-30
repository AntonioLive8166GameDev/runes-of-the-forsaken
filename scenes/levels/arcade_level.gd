class_name ArcadeLevel
extends Node2D
## Clase diseñada para los niveles del modo Arcade.
##
## Esta clase ofrece la posibilidad de eliminarse del árbol de escenas emitiendo antes una señal
## al llamar su método [method ArcadeLevel.end_level]. Esto permite tomar acciones cuando
## el nivel finalice.
##
## @experimental: Esta clase aún está siendo probada, por lo que su funcionalidad es limitada.

## Señal emitida al llamar el método [method ArcadeLevel.end_level].
signal level_ended


## Elimina la escena actual del árbol de escenas y emite [signal ArcadeLevel.level_ended].
func end_level() -> void:
	emit_signal("level_ended")
	queue_free()
