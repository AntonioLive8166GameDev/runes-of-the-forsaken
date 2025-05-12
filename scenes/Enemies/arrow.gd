class_name Arrow
extends Area2D
## @experimental

signal damage_player(amount)


@export var atk : int = 20
@export var speed : int = 200
var target_direction : Vector2 = Vector2.ZERO


func _ready() -> void:
	look_at(target_direction)


func _process(delta: float) -> void:
	position += speed  * target_direction * delta

## Needs to be called from the parent node to stablish where te arrow will go.
func set_target_direction(direction: Vector2) -> void:
	target_direction = -direction


## Hits the player ant then is free
func _on_player_hit(area: Area2D) -> void:
	if area.is_in_group("players"):
		emit_signal("damage_player", atk)
		queue_free()
