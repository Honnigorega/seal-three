class_name BulletComponent
extends Node

@export var bullet_node: Node2D

@export var speed := 1200.0
@export var size := 1.0
@export var damage := 1
@export var accuracy := 100.0
@export var max_random_spread := 0.5
@export var speed_variation := 0.0
@export var is_piercing := false
@export var pierce_value := 1

var random_spread := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Check required components
	assert(bullet_node, "ERROR: You must provide a bullet_node.")

	bullet_node.scale = Vector2(size, size)
	if accuracy < 100.0: random_spread = get_random_spread_value()
	if speed_variation > 0.0: speed = calculate_speed_variation()
	bullet_node.rotation += randf_range(-random_spread, random_spread)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	bullet_node.position += bullet_node.transform.x * speed * delta

func get_random_spread_value() -> float:
	return max_random_spread * (100 - accuracy) / 100
	
func calculate_speed_variation() -> float:
	return randf_range(speed - speed_variation, speed + speed_variation)
