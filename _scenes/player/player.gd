extends Area2D

@export var hitbox: Hitbox
@export var hurtbox: Hitbox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Check required components
	assert(hitbox, "ERROR: You must provide a hitbox.")
	assert(hurtbox, "ERROR: You must provide a hurtbox.")
	
	# Set a global reference to the player node
	Global.player_node = self 
	
	# Signal handlers
	hitbox.hit.connect(_on_hit)
	hurtbox.hit.connect(_on_hit)

func _on_hit(_area: Area2D) -> void:
	print("Game Over")
