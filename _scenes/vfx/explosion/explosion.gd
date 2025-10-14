extends Node2D

@onready var all_explosions := get_children()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var new_explosion = all_explosions.pick_random()
	new_explosion.get_node("AnimatedSprite2D").animation_finished.connect(_on_animation_finished)
	new_explosion.show()

func _on_animation_finished() -> void:
	queue_free()
