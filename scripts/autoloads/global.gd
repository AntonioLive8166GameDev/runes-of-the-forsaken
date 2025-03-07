extends Node

# Variable para guardar el input del usuario.
var axis : Vector2


# Obtener los ejes del input mediante operaciónes aritméticas simples.
func get_axis() -> Vector2:
	axis.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	axis.y = int(Input.is_action_pressed("up")) - int(Input.is_action_pressed("down"))
	return axis.normalized() # Se devuelve el valor normalizado para evitar que el movimiento en diagonal sea más rápido.
