class_name Enemy
extends Node

@export var health_component: HealthComponent
@export var hitbox: Hitbox
@export var hurtbox: Hitbox
@export var enemy_visuals: EnemyVisuals
@export var brain_chip: BrainChip = BrainChip.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Check required enemy components
	assert(health_component, "ERROR: You must provide a health component.")
	assert(hitbox, "ERROR: You must provide a hitbox.")
	assert(hurtbox, "ERROR: You must provide a hurtbox.")
	assert(enemy_visuals, "ERROR: You must provide enemy visuals.")
	
	# Signal handlers
	health_component.death.connect(_on_enemy_death)

	# Signal handlers
	hitbox.hit.connect(_on_hitbox_hit)
	hurtbox.hit.connect(_on_hurtbox_hit)

func _on_hitbox_hit(area: Area2D) -> void:
	if area.is_in_group("hitbox") && area.owner.is_in_group("player_bullet"):
		health_component.reduce_health(area.owner.bullet_component.damage)

func _on_hurtbox_hit(area: Area2D) -> void:
	if area.is_in_group("hurtbox") && area.owner.is_in_group("player"):
		queue_free()

func _on_enemy_death() -> void:
	enemy_visuals.show_explosion()
	queue_free()
