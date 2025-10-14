class_name HealthComponent
extends Node

signal death

@export var max_health: int = 1
@export var hitbox_list: Array[Hitbox]

@onready var health := max_health:
	set(value):
		health = value
		if health <= 0:
			death.emit()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Check required components
	assert(hitbox_list.size() > 0, "ERROR: You must provide at least 1 hitbox.")

	for hitbox in hitbox_list:
		hitbox.hit.connect(_on_hitbox_hit)

func _on_hitbox_hit(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		health -= area.bullet_component.damage
