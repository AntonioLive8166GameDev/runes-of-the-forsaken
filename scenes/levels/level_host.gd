extends Node2D

# TODO: Make an automatic preload system based on file system and not manually colocations.
## Contiene las escenas de los niveles precargados. Sirven como referencia.
@export var levels : Array[PackedScene] = [
	preload("res://scenes/levels/test_level.tscn"),
	preload("res://scenes/levels/test_level1.tscn"),
	preload("res://scenes/levels/test_level2.tscn"),
]
## Sirve como una copia de [u]levels[/u] para trabajar de manera segura.
var _levels : Array[PackedScene] = levels.duplicate()


func _ready() -> void:
	#var level : int = 0
	#while FileAccess.file_exists("res://scenes/levels/level_" + str(level) + ".tscn"):
		#var path : String = "res://scenes/levels/level_{}.tscn".format(level)
		#levels.append(preload(path))
	
	# "Barajamos" los elementos de _levels para mejorar la aleatoriedad.
	_levels.shuffle()
	select_random_level()


## Selecciona e instancia una escena de las disponibles en [u]_levels[/u] para posteriormente agregarla al árbol de escenas.
func select_random_level() -> void:
	# Verificamos si _levels esta vacío, si lo está, le asignamos una copia de levels y lo volvemos a "barajar".
	if _levels.is_empty():
		_levels = levels.duplicate()
		_levels.shuffle()
	
	# Selecciona un elemento de _levels, se guarda una instancia en last_level y luego se elimina de _levels para garantizar
	# que no pueda ser elegido consecutivamente.
	var last_level = _levels.pop_front().instantiate()
	add_child(last_level)
	# Ahora que uno de los niveles/escenarios ha sido añadido al árbol de escenas, podemos conectar su señal "level_ended" con
	# el método que necesitemos (con fines de depuración, actualmente la conecté a esta misma función).
	last_level.level_ended.connect(_on_arcade_level_level_ended)


## Una señal proveniente del nivel en curso se cnonecta con esta función cuando éste finaliza.
func _on_arcade_level_level_ended() -> void:
	select_random_level()
