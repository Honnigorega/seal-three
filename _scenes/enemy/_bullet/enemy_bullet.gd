class_name EnemyBullet
extends Area2D

# Every bullet needs a bullet component and a kill timer component
@export var bullet_component: BulletComponent
@export var kill_timer_component: KillTimerComponent
@export var hitbox: Hitbox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Check required components
	assert(bullet_component, "ERROR: You must provide a bullet component.")
	assert(kill_timer_component, "ERROR: You must provide a kill timer component.")
	assert(hitbox, "ERROR: You must provide a hitbox.")
	
	## Signal handlers
	hitbox.hit.connect(_on_hitbox_hit)

func _on_hitbox_hit(area: Area2D) -> void:
	if area.is_in_group("hitbox") && area.owner.is_in_group("player"):
		# Enemy bullet hit a player hitbox
		queue_free()
