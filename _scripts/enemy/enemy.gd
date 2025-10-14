extends Node

@export var health_component: HealthComponent
@export var hitbox: Hitbox
@export var hurtbox: Hitbox
@export var enemy_visuals: EnemyVisuals

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Check required enemy components
	assert(health_component, "ERROR: You must provide a health component.")
	assert(hitbox, "ERROR: You must provide a hitbox.")
	assert(hurtbox, "ERROR: You must provide a hurtbox.")
	assert(enemy_visuals, "ERROR: You must provide enemy visuals.")
	
	# Signal handlers
	health_component.death.connect(_on_enemy_death)

func _on_enemy_death() -> void:
	enemy_visuals.show_explosion()
	queue_free()
