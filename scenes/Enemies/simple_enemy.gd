extends CharacterBody2D

@export var max_health: int = 100
var current_health: int

func _ready():
	current_health = max_health


func take_damage(amount: int) -> void:
	current_health -= amount
	print("Enemigo recibió daño. Salud restante:", current_health)
	
	if current_health <= 0:
		# TODO: Realizar animación (cuando haya assets xd).
		die()

func die() -> void:
	print("¡El enemigo ha sido derrotado!")
	queue_free()  # Elimina al enemigo de la escena.


# Cuando el enemigo es atacado, conecta la señal "attack" con take_damage().
func _on_damage_trigger_weapon_entered(weapon: Area2D) -> void:
	# Verifica si el objeto es efectivamente un arma o proyectil y si la señal aún no está conectada.
	if weapon.is_in_group("weapons") and not weapon.is_connected("attack", take_damage):
		weapon.connect("attack", take_damage);
		if weapon.is_connected("attack", take_damage):
			print("signal \"attack\" connected to take_damage()")


# Cuando el arma salga del cuerpo, desconecta la señal para evitar recibir daño por bluetooth XD.
func _on_damage_trigger_weapon_exited(weapon: Area2D) -> void:
	# Se espera un poco para aumentar un poco la vulnerabilidad.
	await get_tree().create_timer(.5).timeout
	# Verifica si el objeto es efectivamente un arma o proyectil y si la señal aún está conectada.
	if weapon.is_in_group("weapons") and weapon.is_connected("attack", take_damage):
		weapon.disconnect("attack", take_damage);
		if not weapon.is_connected("attack", take_damage):
			print("signal \"attack\" disconected from take_damage()")
