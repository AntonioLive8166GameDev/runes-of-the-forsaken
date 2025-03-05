extends Node

# Stores the input from user in two axis
var axis : Vector2


# Gets the input axis
func get_axis() -> Vector2:
	axis.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	axis.y = int(Input.is_action_pressed("up")) - int(Input.is_action_pressed("down"))
	return axis.normalized() # It's normalized to avoid increased speed when there's input on both vectors
