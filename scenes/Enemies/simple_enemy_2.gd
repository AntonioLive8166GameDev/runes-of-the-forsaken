extends CharacterBody2D

@export var max_health: int = 100
@export var speed: int = 250
@export var attack_damage: int = 20
@export var attack_cooldown: float = 1.5 # En segundos


var current_health: int
var _player: Node2D = null
var _can_attack: bool = true
var _target: Node2D = null

func _ready():
	current_health = max_health
	$AnimatedSprite2D.play("walk")

func _process(_delta: float) -> void:
	# Si el jugador está dentro del rango de detección, muévete hacia él.
	if _player != null:
		var angle = get_angle_to(_player.global_position)
		if rad_to_deg(angle) >= -80 and rad_to_deg(angle) <= 80:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true
		var direction = Vector2(cos(angle), sin(angle))
		velocity = direction * speed
		move_and_slide()
		# Obtener el ángulo actual de la espada
		var current_angle = $Sword_Area2D.rotation

		# Calcular el ángulo hacia el jugador
		var target_angle = ($Sword_Area2D.global_position.direction_to(_player.global_position)).angle()

		# Interpolación suave del ángulo actual hacia el objetivo
		$Sword_Area2D.rotation = lerp_angle(current_angle, target_angle, 0.05)
	
	if _target != null and _can_attack:
		$Sword_Area2D.emit_signal("damage_player", attack_damage)
		_can_attack = false
		$AnimatedSprite2D.play("attack")
		await $AnimatedSprite2D.animation_finished
		$AnimatedSprite2D.play("walk")
		print("Ya jala we :(")
		$Cooldown.start()

func take_damage(amount: int) -> void:
	current_health -= amount
	$AnimatedSprite2D.play("damage")
	$SEnemy2SFX.stream = preload("res://resourses/sfx/enemy_hit.wav")
	$SEnemy2SFX.play()
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("walk")
	print("El enemigo recibió daño. Vida restante:", current_health)
	if current_health <= 0:
		die()

func die() -> void:
	$EnemyCollision.disabled = true
	$Sword_Area2D.monitoring = false
	$DetectionArea2D.monitoring = false
	$DamageTrigger.monitoring = false
	$SEnemy2SFX.stream = preload("res://resourses/sfx/enemy_killed.wav")
	$SEnemy2SFX.play()
	await $SEnemy2SFX.finished
	print("¡Enemigo muelto!")
	queue_free()


#region Ataque con espada (hitbox)
# Cuando la espada del enemigo (otra Area2D) entra en contacto con el jugador.
func _on_sword_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		_target = body
#endregion


func _on_sword_area_2d_body_exited(body: Node2D) -> void:
	if body == _target:
		_target = null


# Cuando el jugador entra, lo sigue.
func _on_detection_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		_player = body


# Cuando el jugador se sale, deja de perseguirlo.
#func _on_detection_area_2d_body_exited(body: Node2D) -> void:
	#if body == _player:
		#_player = null


#region Cooldown
# Cuando termina el temporizador de cooldown, se puede volver a atacar.
func _on_cooldown_timeout() -> void:
	_can_attack = true
#endregion


func _on_damage_trigger_area_entered(weapon: Area2D) -> void:
	# Verifica si el objeto es efectivamente un arma o proyectil y si la señal aún no está conectada.
	if weapon.is_in_group("weapons") and not weapon.is_connected("attack", take_damage):
		weapon.connect("attack", take_damage);
		if weapon.is_connected("attack", take_damage):
			print("signal \"attack\" connected to take_damage()")


#func _on_damage_trigger_area_exited(weapon: Area2D) -> void:
	#await get_tree().create_timer(.5).timeout
	## Verifica si el objeto es efectivamente un arma o proyectil y si la señal aún está conectada.
	#if weapon.is_in_group("weapons") and weapon.is_connected("attack", take_damage):
		#weapon.disconnect("attack", take_damage);
		#if not weapon.is_connected("attack", take_damage):
			#print("signal \"attack\" disconnected from take_damage()")
