extends CharacterBody2D

@export var speed : int = 100


func _process(_delta: float) -> void:
	motion()


# Hace que el jugador se mueva cambiando la propiedad velocity del nodo CharacterBody2D (Player).
func motion() -> void:
	velocity.x = GLOBAL.get_axis().x * speed
	velocity.y = GLOBAL.get_axis().y * -speed
	move_and_slide()
