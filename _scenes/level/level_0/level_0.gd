extends Node

@onready var player_spawn_point = $PlayerSpawnPoint
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(player, "ERROR: You must add the Player to the level scene.")
	# Set player position to spawn
	player.position = player_spawn_point.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
