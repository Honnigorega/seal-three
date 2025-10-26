@tool
extends Node

var game_ui # reference to the game ui node
var player_node # reference to the player node
var current_level # reference to the current level node

enum TrigonometricFunction {
	SIN,
	COS
}

enum Enemy {
	LILY_OF_THE_VALLEY,
	HIBISCUS,
	ROTATING_GROUP
}

enum SpawnDirection {
	TOP,
	BOTTOM,
	LEFT,
	RIGHT
}

## Dictionary that connects enemy types with scenes to use
var enemy_scene_dict = {
	Global.Enemy.LILY_OF_THE_VALLEY: load("res://_scenes/enemy/lily_of_the_valley/lily_of_the_valley.tscn"),
	Global.Enemy.HIBISCUS: load("res://_scenes/enemy/hibiscus/hibiscus.tscn")
}

## Dictionary that connects enemy types with sprites to use
var enemy_sprite_dict = {
	Enemy.LILY_OF_THE_VALLEY: load("res://_assets/enemy/lily_of_the_valley/lily_of_the_valley.png"),
	Enemy.HIBISCUS: load("res://_assets/enemy/hibiscus/hibiscus.png")
}
