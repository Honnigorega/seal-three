extends Node

@onready var player_spawn_point = $PlayerSpawnPoint
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Check required components
	assert(player, "ERROR: You must add the Player to the level scene.")
	
	# Set player position to spawn
	player.position = player_spawn_point.position
