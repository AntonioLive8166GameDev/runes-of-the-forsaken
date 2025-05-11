extends CharacterBody2D

@export var max_health: int = 100
@export var speed: int = 450
var direction: Vector2 = Vector2.ZERO
var current_health: int

var _target: Node2D = null
var _player: Node2D = null
var arrow: PackedScene = preload("res://scenes/enemies/arrow.tscn")
func _ready():
	current_health = max_health


func _process(_delta: float) -> void:
	if _player != null:
		var angle = get_angle_to(_player.global_position)
		direction = -Vector2(cos(angle), sin(angle))
		velocity = speed * direction
		move_and_slide()
	
	if _target != null:
		var angle = get_angle_to(_target.global_position)
		direction = -Vector2(cos(angle), sin(angle))


func take_damage(amount: int):
	current_health -= amount
	print("El arquero recibió daño. Salud restante:", current_health)
	
	if current_health <= 0:
		# TODO: Realizar animación (cuando haya assets xd).
		die()

func die():
	print("¡El arquero ha sido derrotado!")
	queue_free()  # Elimina al enemigo de la escena.


func shoot():
	var _arrow_instance = arrow.instantiate()
	add_child(_arrow_instance)
	#_arrow_instance.position = self.global_position
	_arrow_instance.set_target_direction(direction)


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
			print("signal \"attack\" disconnected from take_damage()")


func _on_player_margin_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		_player = body


func _on_player_margin_body_exited(body: Node2D) -> void:
	if body.is_in_group("players"):
		_player = null


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		_target = body
		$Cooldown.start()


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("players"):
		$Cooldown.stop()
		_target = null
