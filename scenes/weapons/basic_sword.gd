extends Area2D

signal attack(damage)

@export var damage: int = 20

# Variable que indica si se está atacando o no. (Inicia en falso).
var is_attacking: bool = false

func _process(_delta: float) -> void:
	# Cuando no se está atacando, la espada sigue apuntando hacia el mouse.
	if not is_attacking:
		look_at(get_global_mouse_position())

func _input(event):
	# Verifica si se ha presionado el botón izquierdo del mouse.
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and not is_attacking:
			perform_attack()

func perform_attack() -> void:
	# Marca que se está realizando un ataque, evitando que se interrumpa el ataque con otro ataque.
	is_attacking = true

	# Guarda la rotación inicial y calcula la rotación objetivo (135° hacia la derecha).
	var initial_rotation = rotation
	var attack_rotation = initial_rotation + deg_to_rad(135)

	# tween para el efecto visual (animación).
	var tween = get_tree().create_tween()
	# Primer tramo: gira 135° en 0.2 s (derecha).
	tween.tween_property(self, "rotation", attack_rotation, 0.2)\
		 .set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	# Segundo tramo: vuelve a la rotación inicial en 0.2 s
	tween.tween_property(self, "rotation", initial_rotation, 0.2)\
		 .set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	# Al terminar las dos fases, lanzamos la transición final (posición actual del puntero).
	tween.connect("finished", Callable(self, "_on_attack_animation_finished"))

func _on_attack_animation_finished() -> void:
	# Capturamos dónde está el mouse ahora y tween a esa rotación en 0.2 s.
	var target_angle = (get_global_mouse_position() - global_position).angle()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "rotation", target_angle, 0.2)\
		 .set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.connect("finished", Callable(self, "_attack_finished"))

func _attack_finished() -> void:
	# Finaliza el ataque y reanuda el seguimiento normal del mouse.
	is_attacking = false


# Emite la señal "attack" si se está atacando para dañar al enemigo.
func _on_enemy_entered(enemy: Area2D) -> void:
	if enemy.is_in_group("enemies") and is_attacking:
		# TODO: Programar multiplicador de daño con base en el atk del jugador y mejoras del arma.
		emit_signal("attack", damage)
