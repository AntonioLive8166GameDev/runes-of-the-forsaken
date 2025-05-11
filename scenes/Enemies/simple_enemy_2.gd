extends CharacterBody2D

@onready var actionArea = $Area2D

func _physics_process(delta: float) -> void:
	check_actionables()
	
func check_actionables() -> void:
	# Todo lo que esté colisionando en ese momento con el ActionArea lo traiga y lo guarde en el Array
	var areas: Array[Area2D] = actionArea.get_overlapping_areas()
	for area in areas:
		queue_free()
