@tool
class_name EnemySpawnTrigger
extends VisibleOnScreenNotifier2D

enum SpawnDirection {
	TOP,
	BOTTOM,
	LEFT,
	RIGHT
}

var enemy_scene_dict = {
	Global.Enemy.LILY_OF_THE_VALLEY: load("res://_scenes/enemy/lily_of_the_valley/lily_of_the_valley.tscn"),
	Global.Enemy.HIBISCUS: load("res://_scenes/enemy/hibiscus/hibiscus.tscn")
}

@export var spawn_direction: SpawnDirection = SpawnDirection.RIGHT:
	set(value):
		spawn_direction = value
		$EnemySpawnSprite.set_sprite_position_by_spawn_direction(spawn_direction)

## Which type of enemy will be spawned
@export var enemy_type: Global.Enemy = Global.Enemy.LILY_OF_THE_VALLEY:
	set(value):
		enemy_type = value
		$EnemySpawnSprite.change_sprite_by_enemy_type(value)
		$EnemySpawnSprite.set_sprite_position_by_spawn_direction(spawn_direction)

## Brain chip to be used for behavior instructions
@export var brain_chip: BrainChip = BrainChip.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$EnemySpawnSprite.change_sprite_by_enemy_type(enemy_type)
	if !Engine.is_editor_hint():
		screen_entered.connect(_on_screen_entered)
		$EnemySpawnSprite.hide()
		
func _on_screen_entered() -> void:
	# Spawn the specified enemy type
	_spawn_enemy_by_type(enemy_type)
 
func _spawn_enemy_by_type(type: Global.Enemy) -> void:
	var enemy = enemy_scene_dict[type].instantiate()
	enemy.position = $EnemySpawnSprite.global_position
	var enemy_brain = enemy.get_node_or_null("Brain")
	if enemy_brain && brain_chip:
		enemy_brain.brain_chip = brain_chip
	get_tree().root.add_child(enemy)
