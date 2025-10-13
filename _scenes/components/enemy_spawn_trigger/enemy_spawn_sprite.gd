@tool
extends Sprite2D

## Dictonary that connects enemy types with sprites to use
var enemy_sprite_dict = {
	Global.Enemy.LILY_OF_THE_VALLEY: load("res://_assets/enemy/lily_of_the_valley/lily_of_the_valley.png"),
	Global.Enemy.HIBISCUS: load("res://_assets/enemy/hibiscus/hibiscus.png")
}

func change_sprite_by_enemy_type(enemy_type: Global.Enemy) -> void:
	texture = enemy_sprite_dict[enemy_type]
	position = Vector2(get_rect().size.x,0)
