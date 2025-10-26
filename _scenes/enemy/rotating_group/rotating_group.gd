class_name RotatingGroup
extends Node2D

# List of enemies in the group
var enemy_group: Array[Global.Enemy] = []

## Inside which range will the group be spread, 2 * PI being 360°
var group_spread := 2 * PI
## How big is the radius for the spread
var group_radius := 40.0
## Used as rotation speed modifier
var rotation_modifier := 0.01
## 1 = clockwise, -1 = counterclockwise
var rotation_direction := 1

@onready var rotation_step := group_spread / enemy_group.size()

func _ready() -> void:
	for i in enemy_group.size():
		var new_enemy = Global.enemy_scene_dict[enemy_group[i]].instantiate()
		new_enemy.position = Vector2(group_radius * cos(rotation_step * i), group_radius * sin(rotation_step * i))
		$Enemies.add_child(new_enemy)

func _process(_delta: float) -> void:
	rotation += 0.01 * rotation_direction
	for enemy in $Enemies.get_children():
		enemy.global_rotation = 0.0
