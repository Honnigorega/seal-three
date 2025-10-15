extends Node

@export var player: Player
@export var player_spawn_point: Marker2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Check required components
	assert(player, "ERROR: You must provide a player.")
	assert(player_spawn_point, "ERROR: You must provide a player spawn point.")

	# Signal handlers
	player.death.connect(_on_player_death)
	
	# Set player position to spawn
	player.position = player_spawn_point.position

func _on_player_death() -> void:
	reset_level()
	reset_player()

@onready var background_initial_offset = $Background.scroll_offset
@onready var enemy_spawns_initial_offset = $EnemySpawns.scroll_offset

func reset_level() -> void:
	get_tree().call_group("player_bullet", "queue_free")
	get_tree().call_group("enemy_bullet", "queue_free")
	get_tree().call_group("enemy", "queue_free")
	
	# TODO: Implement a "checkpoint" system
	# This can be either just a set point in the level, 
	# but to make it more interesting it could be something like in shovel knight
	# that you can either activate or not. if you dont use the checkpoints you will get more score
	# achievement etc

	## How far the level will be set back in px
	var level_setback_value := 200.0
	var background_tween_to_position := Vector2(minf($Background.scroll_offset.x + level_setback_value, $Background.repeat_size.x), 0)
	var enemy_spawns_tween_to_position := Vector2(minf($EnemySpawns.scroll_offset.x + level_setback_value, $EnemySpawns.repeat_size.x), 0)
	
	var level_reset_tween := create_tween()
	level_reset_tween.set_parallel(true)
	level_reset_tween.tween_property($Background, "scroll_offset", background_tween_to_position, 1.0)
	level_reset_tween.tween_property($EnemySpawns, "scroll_offset", enemy_spawns_tween_to_position, 1.0)

func reset_player() -> void:
	# TODO: Add i-frames (animation, disable hitbox) for the player
	# TODO: Reset score and other stats (power ups, ...) as deemed necessary
	var player_reset_tween := create_tween()
	player_reset_tween.tween_property(player, "position", player_spawn_point.position, 1.0)
