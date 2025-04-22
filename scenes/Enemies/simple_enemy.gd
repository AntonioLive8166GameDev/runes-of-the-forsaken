extends CharacterBody2D

@export var max_health: int = 100
var current_health: int

func _ready():
	current_health = max_health
	input_pickable = true  # Detectar clicks

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		take_damage(25)  # Cantidad de daño

func take_damage(amount: int):
	current_health -= amount
	print("Enemigo recibió daño. Salud restante:", current_health)
	
	if current_health <= 0:
		die()

func die():
	print("¡El enemigo ha sido derrotado!")
	queue_free()  # Elimina al enemigo de la escena
