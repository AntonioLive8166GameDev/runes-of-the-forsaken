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
var enemy_positions : Array[Node]
var enemy : Array[PackedScene] = [
	preload("res://scenes/enemies/simple_enemy_3.tscn")
]
var spawn_range = 300
var _is_player_alive : bool = true


func _ready() -> void:
	enemy_positions = $EnemyStartPositions.get_children()
	# Añade el jugador a la escena y cambia su posición.
	add_child(_player_instance)
	$Player.connect("dead_player", game_over)
	$Player.scale = Vector2(0.25,0.25)
	$Player.position = $PlayerStartPos.position
	$Player.speed = 250
	$Player.hp = 1000
	# TODO: Instancia de enemigos, items y esa wea yatusabe.


func _process(delta: float) -> void:
	pass

func spawn_enemies() -> void:
	if _is_player_alive:
		for marker in enemy_positions:
			if marker.position.distance_to($Player.position) <= spawn_range:
				var enemy_instance = enemy[randi_range(0, enemy.size() - 1)].instantiate()
				enemy_instance.position = marker.position
				add_child(enemy_instance)


func game_over() -> void:
	_is_player_alive = false

## Emite [signal ArcadeLevel.level_ended] y elimina la escena actual del árbol de escenas.
func end_level() -> void:
	emit_signal("level_ended")
	queue_free()
