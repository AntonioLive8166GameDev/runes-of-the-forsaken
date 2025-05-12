extends CharacterBody2D

@export var max_health: int = 100
@export var speed: int = 250
@export var attack_damage: int = 20
@export var attack_cooldown: float = 1.5 # En segundos
signal damage_player(damage: int)

var current_health: int
var _player: Node2D = null
var _can_attack: bool = true
var _target: Node2D = null

func _ready():
	current_health = max_health

func _process(_delta: float) -> void:
	# Si el jugador está dentro del rango de detección, muévete hacia él.
	if _player:
		var direction = (_player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
	if _target:
		emit_signal("damage_player", attack_damage)
		print("Ya jala we :(")
		_can_attack = false
		$Cooldown.start()

func take_damage(amount: int) -> void:
	current_health -= amount
	print("El enemigo recibió daño. Vida restante:", current_health)
	if current_health <= 0:
		die()

func die() -> void:
	print("¡Enemigo muelto!")
	queue_free()


#region Detección del jugador
# Se activa cuando el jugador entra al área de detección (Area2D con colisión más grande).
func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		_player = body

# Se desactiva cuando el jugador sale del área de detección.
func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == _player:
		_player = null
#endregion


#region Ataque con espada (hitbox)
# Cuando la espada del enemigo (otra Area2D) entra en contacto con el jugador.
func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		_target = body
#endregion


#region Cooldown
# Cuando termina el temporizador de cooldown, se puede volver a atacar.
func _on_cooldown_timeout() -> void:
	_can_attack = true
#endregion


func _on_sword_area_2d_body_exited(body: Node2D) -> void:
	if body == _target:
		_target = null
