class_name Player
extends CharacterBody2D
## Clase diseñada para los personajes jugables.
##
## Incluye una función para controlar el movimiento y variables para sus estadísticas.
## @experimental: Aún faltan algunas estadísticas y métodos.

@export_group("Estadísticas")
@export var speed : int = 100
@export var hp : int = 100
@export var defense : int = 100
@export var atk : int = 50


func _process(_delta: float) -> void:
	motion()


## Hace que el jugador se mueva cambiando la propiedad [param velocity] del nodo [CharacterBody2D] ([b]Player[/b]).
func motion() -> void:
	velocity.x = GLOBAL.get_axis().x * speed
	velocity.y = GLOBAL.get_axis().y * -speed
	move_and_slide()


# INFO: BasicSword fue añadido temporalmente como hijo, pero debería cambiarse esto al implementar más armas.
