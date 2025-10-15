class_name PlayerBullet
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
	if area.is_in_group("hitbox") && area.owner.is_in_group("enemy"):
		# Player bullet hit an enemy hitbox
		if bullet_component.is_piercing && bullet_component.pierce_value > 0:
			bullet_component.pierce_value -= 1
		else:
			queue_free()
