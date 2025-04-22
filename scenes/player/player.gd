class_name Player
extends CharacterBody2D
## Clase diseñada para los personajes jugables.
##
## Incluye una función para controlar el movimiento y variables para sus estadísticas.
## @experimental: Aún faltan algunas estadísticas y métodos.

@export_group("Estadísticas")
@export var speed : int = 100 ## Velocidad del jugador.
@export var hp : int = 100 ## Vida del jugador.
@export var defense : int = 100 ## Defensa o resistencia ante ataques del jugador.
@export var atk : int = 50 ## Multiplicador de daño de ataque.
@export var invulnerable : bool = false ## Si el jugador puede recibir daño o no.


func _process(_delta: float) -> void:
	motion()


## Hace que el jugador se mueva cambiando la propiedad [param velocity] del nodo [CharacterBody2D] ([b]Player[/b]).
func motion() -> void:
	velocity.x = GLOBAL.get_axis().x * speed
	velocity.y = GLOBAL.get_axis().y * -speed
	move_and_slide()


func take_damage(damage : int):
	# TODO: Programar disminución de daño recibido ante ataques (defensa).
	hp -= damage
	if hp <= 0:
		die()


func die():
	# TODO: Programar la morision.
	pass


# INFO: BasicSword fue añadido temporalmente como hijo, pero debería cambiarse esto al implementar más armas.
