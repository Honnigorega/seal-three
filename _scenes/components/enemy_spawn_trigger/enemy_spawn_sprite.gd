@tool
extends Sprite2D

## Dictionary that connects enemy types with sprites to use
var enemy_sprite_dict = {
	Global.Enemy.LILY_OF_THE_VALLEY: load("res://_assets/enemy/lily_of_the_valley/lily_of_the_valley.png"),
	Global.Enemy.HIBISCUS: load("res://_assets/enemy/hibiscus/hibiscus.png")
}

func change_sprite_by_enemy_type(enemy_type: Global.Enemy) -> void:
	texture = enemy_sprite_dict[enemy_type]

func set_sprite_position_by_spawn_direction(direction: EnemySpawnTrigger.SpawnDirection) -> void:
	match direction:
		EnemySpawnTrigger.SpawnDirection.TOP:
			position = Vector2(0,-get_rect().size.y)
		EnemySpawnTrigger.SpawnDirection.BOTTOM:
			position = Vector2(0,get_rect().size.y)
		EnemySpawnTrigger.SpawnDirection.LEFT:
			position = Vector2.ZERO
			global_position.x = -get_rect().size.x
		EnemySpawnTrigger.SpawnDirection.RIGHT:
			position = Vector2(get_rect().size.x,0)
		_:
			position = Vector2(get_rect().size.x,0)
