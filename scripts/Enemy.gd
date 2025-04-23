class_name Enemy
extends Node
## Un enemigo simple. Contiene lo necesario para dañar al jugador, y para recibir daño.
##
## Aunque la clase no debe usarse, el [color=aqua]código de este script es funcional[/color], para usarlo, crea una escena con su propio
##script y pega el contenido que necesites de este ahí. Si buscas hacer un [b]proyectil disparado en línea recta[/b], usa [Arrow] en su lugar.
## @deprecated: Esta clase es un prototipo creado con fines de documentación. [color=red]No debe usarse[/color] (leer descripción completa).

## Señal requerida para dañar al jugador.[br][color=yellow]Advertencia:[/color] el nombre de la señal no puede
## ser cambiado, sólo el de su [u]parámetro[/u]; [b]pero no la cantidad de parámetros ni su tipo[/b].
signal damage_player(amount: int)

@export_group("Estadísticas")
@export var hp : int = 100 ## Vida base.
@export var atk : int = 20 ## Ataque base.
@export var speed : int = 200 ## Velocidad base.


## Reduce [param hp] con base en [param damage]; si se reduce a [code]0[/code] o a menos, llama a [method Player.die].
func take_damage(damage: int):
	hp -= damage
	if hp <= 0:
		die()


## Deshabilita la colisión del enemigo y ejecuta la animación de muerte para luego quitarlo del árbol de escenas.
func die():
	# Desactivar la colisión para evitar que siga recibiendo daño.
	$EnemyCollision.set_deferred("disabled", true) # Es lo mismo que $EnemyCollision.disabled = true, pero más mamalon.
	# *insertar animación de muerte*
	queue_free()


## Emite la señal [signal Enemy.damage_player] si [param body] está en el grupo [code]"players"[/code].
func _on_body_hit(body: Node) -> void:
	if body.is_in_group("players"):
		emit_signal("damage_player", atk)


#region damage trigger
## Cuando el enemigo es atacado por el jugador, conecta la señal [signal Enemy.damage_player] con [method Enemy.take_damage].
func _on_damage_trigger_weapon_entered(weapon: Area2D) -> void:
	# Verifica si el objeto es efectivamente un arma o proyectil y si la señal aún no está conectada.
	if weapon.is_in_group("weapons") and not weapon.is_connected("attack", take_damage):
		weapon.connect("attack", take_damage);
		if weapon.is_connected("attack", take_damage):
			print("signal \"attack\" connected to take_damage()")


## Cuando el arma salga del enemigo, desconecta la señal [signal Enemy.damage_player] para evitar recibir daño a distancia.
func _on_damage_trigger_weapon_exited(weapon: Area2D) -> void:
	# Se espera un poco para aumentar un poco la vulnerabilidad.
	await get_tree().create_timer(.5).timeout
	# Verifica si el objeto es efectivamente un arma o proyectil y si la señal aún está conectada.
	if weapon.is_in_group("weapons") and weapon.is_connected("attack", take_damage):
		weapon.disconnect("attack", take_damage);
		if not weapon.is_connected("attack", take_damage):
			print("signal \"attack\" disconected from take_damage()")
#endregion
