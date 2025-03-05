extends CharacterBody2D

@export var speed : int = 100


func _process(_delta: float) -> void:
	motion()


# Makes player move changing the CharacterBody2D velocity property to the input of player * the speed
func motion() -> void:
	velocity.x = GLOBAL.get_axis().x * speed
	velocity.y = GLOBAL.get_axis().y * -speed
	move_and_slide()
