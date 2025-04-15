class_name ArcadeLevel
extends Node2D
## Clase diseñada para los niveles del modo Arcade.
##
## Esta clase ofrece la posibilidad de eliminarse del árbol de escenas emitiendo antes una señal
## al llamar su método [method ArcadeLevel.end_level]. Esto permite tomar acciones cuando
## el nivel finalice. También añade al jugador al árbol de escenas y cambia su posición. [br]
##
## [color=red]Advertencia:[/color] Se requiere un nodo [u]PlayerStartPos[/u] de clase [Marker2D]
## como hijo del nodo principal. El prámetro [param position] de este nodo se utiliza para establecer
## la posición del [b]jugador[/b]; si el nodo no existe, ocurrirá un error.
##
## @experimental: Esta clase aún está siendo probada, por lo que su funcionalidad es limitada.

## Señal emitida al llamar el método [method ArcadeLevel.end_level].
signal level_ended

## Guarda una instancia del jugador para su manejo.
var _player_instance = preload("res://scenes/player/player.tscn").instantiate()


func _ready() -> void:
	# Añade el jugador a la escena y cambia su posición.
	add_child(_player_instance)
	$Player.position = $PlayerStartPos.position


## Elimina la escena actual del árbol de escenas y emite [signal ArcadeLevel.level_ended].
func end_level() -> void:
	emit_signal("level_ended")
	queue_free()
