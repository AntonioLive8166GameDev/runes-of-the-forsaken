class_name Player
extends CharacterBody2D
## Clase diseñada para los personajes jugables.
##
## Incluye una función para controlar el movimiento y variables para sus estadísticas.
## @experimental

@export_group("Estadísticas")
@export var speed : int = 100 ## Velocidad del jugador.
@export var hp : int = 100 ## Vida del jugador.
@export var defense : int = 100 ## Defensa o resistencia ante ataques recibidos.
@export var atk : int = 50 ## Multiplicador de daño de ataque.
@export var invulnerable : bool = false ## Si es [code]true[/code], puede recibir daño; de lo contrario, no.
var is_alive : bool = true ## Si es [code]false[/code], no puede moverse y se vuelve invulnerable.


func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	motion()


## Hace que el jugador se mueva cambiando los valores de [member CharacterBody2D.velocity] (heredado por [Player]).
func motion() -> void:
	velocity.x = GLOBAL.get_axis().x * speed
	velocity.y = GLOBAL.get_axis().y * -speed
	if is_alive:
		move_and_slide()


## @experimental: Este método está incompleto.
## Reduce [param hp] con base en [param damage]; si se reduce a [code]0[/code] o a menos, llama a [method Player.die].
func take_damage(damage : int):
	# TODO: Programar disminución de daño recibido ante ataques (defensa).
	if not invulnerable:
		hp -= damage
		$PlayerSFX.stream = preload("res://resourses/sfx/damage_received.wav")
		$PlayerSFX.play()
		print("Damage took, hp: ", hp)
		if hp <= 0:
			die()


# TODO: Corregir la documentación cuando se implemente lo de game_over().
## @experimental: Este método está incompleto.
## Deshabilita la colisión del jugador y ejecuta la animación de muerte para luego quitarlo del árbol de escenas.
## Finalmente llama a [method clase.game_over].
func die():
	is_alive = false
	$DamageTrigger.monitoring = false
	$PlayerCollision.disabled = true
	# TODO: Programar la animación.
	$PlayerSFX.stream = preload("res://resourses/sfx/game_over.wav")
	$PlayerSFX.play()
	await $PlayerSFX.finished #TODO: Use finished signal of the AnimationPlayer instead.
	queue_free()


#region damage trigger
## Se ejecuta cuando un enemigo o proyectil de clase [RigidBody2D] o [CharacterBody2D] que pertenezca al grupo [code]"enemies"[/code]
## o [code]"enemy_projectiles"[/code] colisiona con el jugador. Conecta la señal [signal Enemy.damage_player] con [method Player.take_damage]. [br]
## [color=yellow]Advertencia:[/color] La señal [signal Enemy.damage_player] [u]debe[/u] ser emitida con un argumento
## de tipo [code]int[/code], el cuál será pasado a [method Player.take_damage] como [b]daño base[/b].
func _on_damage_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") or body.is_in_group("enemy_projectiles") and not body.is_connected("damage_player", take_damage):
		body.connect("damage_player", take_damage)
		if body.is_connected("damage_player", take_damage):
			print("conectao")


## En caso de que [param body] esté en el grupo [code]"enemies"[/code], desconectará [signal Enemy.damage_player] de [method Player.take_damage]
## Para evitar que el enemigo pueda dañar al jugador fuera del rango. Por otro lado, si [param body] está en el grupo [code]"enemy_projectiles"[/code],
## no hace nada, pues las escenas en este grupo [u]deberían desaparecer[/u] a penas toquen al jugador.
func _on_damage_trigger_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemies") and body.is_connected("damage_player", take_damage):
		body.disconnect("damage_player", take_damage)


## Se ejecuta cuando un enemigo de clase [Area2D] que pertenezca al grupo [code]"enemies"[/code] o [code]"enemy_projectiles"[/code] colisiona
## con el jugador. Conecta la señal [signal Enemy.damage_player] con [method Player.take_damage]. [br] [color=yellow]Advertencia:[/color] 
## La señal [signal Enemy.damage_player] [u]debe[/u] ser emitida con un argumento de tipo [code]int[/code], el
## cuál será pasado a [method Player.take_damage] como [b]daño base[/b].
func _on_damage_trigger_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies") or area.is_in_group("enemy_projectiles") and not area.is_connected("damage_player", take_damage):
		area.connect("damage_player", take_damage)
		if area.is_connected("damage_player", take_damage):
			print("conectao")


## En caso de que [param area] esté en el grupo [code]enemies[/code], desconectará [signal Enemy.damage_player] de [method Player.take_damage]
## Para evitar que el enemigo pueda dañar al jugador fuera del rango. Por otro lado, si [param area] está en el grupo [code]"enemy_projectiles"[/code],
## no hace nada, pues las escenas en este grupo [u]deberían desaparecer[/u] a penas toquen al jugador.
func _on_damage_trigger_area_exited(area: Area2D) -> void:
	if area.is_in_group("enemies") and area.is_connected("damage_player", take_damage):
		area.disconnect("damage_player", take_damage)
#endregion



# INFO: BasicSword fue añadido temporalmente como hijo, pero debería cambiarse esto al implementar más armas.
