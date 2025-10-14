class_name EnemyVisuals
extends Node2D

@export var animated_sprite: AnimatedSprite2D
@export var hitbox: Hitbox

var explosion := preload("res://_scenes/vfx/explosion/explosion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Check required components
	assert(animated_sprite, "ERROR: You must provide an AnimatedSprite2D.")
	assert(hitbox, "ERROR: You must provide a Hitbox.")
	
	hitbox.hit.connect(_on_hitbox_hit)

func _on_hitbox_hit(_area: Area2D) -> void:
	$AnimationPlayer.play("hit_flash")

func show_explosion() -> void:
	var new_explosion = explosion.instantiate()
	new_explosion.position = global_position
	get_tree().root.add_child(new_explosion)
