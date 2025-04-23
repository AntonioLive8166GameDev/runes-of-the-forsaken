class_name Arrow
extends RigidBody2D
## @experimental

signal damage_player(amount)


@export var atk : int = 20
@export var speed : int = 200


func _ready() -> void:
	look_at(get_global_mouse_position())


func _on_player_hit(body: Node) -> void:
	if body.is_in_group("players"):
		emit_signal("damage_player", atk)
