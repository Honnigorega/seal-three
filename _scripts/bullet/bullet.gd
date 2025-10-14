extends Node

# Every bullet needs a bullet component and a kill timer component
@export var bullet_component: BulletComponent
@export var kill_timer_component: KillTimerComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Check required components
	assert(bullet_component, "ERROR: You must provide a bullet component.")
	assert(kill_timer_component, "ERROR: You must provide a kill timer component.")
