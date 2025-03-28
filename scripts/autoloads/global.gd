extends Node

# Variable para guardar el input del usuario.
var axis : Vector2
var _rng = RandomNumberGenerator.new()

# Obtener los ejes del input mediante operaciónes aritméticas simples.
func get_axis() -> Vector2:
	axis.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	axis.y = int(Input.is_action_pressed("up")) - int(Input.is_action_pressed("down"))
	return axis.normalized() # Se devuelve el valor normalizado para evitar que el movimiento en diagonal sea más rápido.

# No tipeamos esta función para tener flexibilidad con los tipos de datos. (A causa de esto pueden surgir errores si se
# introduce un dato no numérico, pero entiendase que se trata de un error humano.
func get_rgn(min_value, max_value): # rgn: Random Generated Number (me lo inventé yo, pero tal vez es real xD).
	# Usamos la función randomize() para cambiar las propiedades "seed" y "state" del RNG.
	_rng.randomize()
	# Devolvemos el número aleatorio. Se usa randf y no randi porque nos permite flexibilidad en caso de necesitar un
	# entero o un flotante.
	return _rng.randf_range(min_value, max_value)
