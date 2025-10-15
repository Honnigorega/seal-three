class_name Player
extends Area2D

signal death

@export var hitbox: Hitbox
@export var hurtbox: Hitbox
## --- Debug ---
@export var god_mode := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Check required components
	assert(hitbox, "ERROR: You must provide a hitbox.")
	assert(hurtbox, "ERROR: You must provide a hurtbox.")
	
	# Set a global reference to the player node
	Global.player_node = self 
	
	# Signal handlers
	hitbox.hit.connect(_on_hitbox_hit)
	hurtbox.hit.connect(_on_hurtbox_hit)

func _on_hitbox_hit(area: Area2D) -> void:
	if god_mode: return
	if area.is_in_group("hitbox") && area.owner.is_in_group("enemy_bullet"):
		# Since the player only has one life currently, any hit will result in death
		death.emit()

func _on_hurtbox_hit(area: Area2D) -> void:
	if god_mode: return
	if area.is_in_group("hurtbox") && area.owner.is_in_group("enemy"):
		# Since the player only has one life currently, any hit will result in death
		death.emit()
