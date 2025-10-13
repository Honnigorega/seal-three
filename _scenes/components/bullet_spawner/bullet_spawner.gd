extends Node2D

enum BulletPattern {
	SINGLE,
	VOLLEY
}

@export var spawner_owner: Node2D ## The owner node the spawner is attached to
@export var bullet_scene: PackedScene ## The bullet to be spawned
@export var input_action: String ## Input action to activate the spawner; not required

@export_group("All")
@export var bullet_pattern := BulletPattern.SINGLE ## Bullet shot pattern
# TODO: Laser Feature (Ultra high firerate e.g. 0.005s, low damage to compensate)
@export var firerate := 1.0 ## Max Firerate in seconds
@export var active := true ## Is the spawner actively creating bullets

@export_group("Single")
# TODO: Burst Feature
@export var burst := false
@export var burst_amount := 2
@export var burst_delay := 0.1
# TODO: Aimed Bullet Feature
@export var target_enemy := false
@onready var initial_rotation := rotation

@export_group("Volley")
@export var bullet_amount := 3
@export var spread_modifier := 0.1
@export var volley_spawn_gap := 0.1
@export var is_spread_reverse := false ## Instead of shooting outwards, shoots inwards

var is_cooldown := false

func _ready() -> void:
	assert(spawner_owner, "ERROR: You must provide a spawner_owner Node2D.")
	assert(bullet_scene, "ERROR: You must provide a bullet_scene.")
	if input_action: assert(InputMap.has_action(input_action), "ERROR: You must provide a '%s' Input Action" % input_action)
	$CooldownTimer.timeout.connect(_on_cooldown_timer_finish)
	$MuzzleFire.hide()

func _process(_delta: float) -> void:
	# Bullet spawner needs to be active and the owner visible
	if !active || !spawner_owner.visible:
		return

	## TODO: Aimed Bullets Feature
	## if target_enemy: #rotate_towards_enemy()
	## else: #rotation = initial_rotation
#
	if Input.is_action_pressed(input_action) && !is_cooldown:
		is_cooldown = true
		$CooldownTimer.start(firerate)
		match bullet_pattern:
			BulletPattern.SINGLE: shoot_single()
			BulletPattern.VOLLEY: shoot_volley()
	if Input.is_action_just_pressed(input_action):
		$MuzzleFire.show()
	if Input.is_action_just_released(input_action):
		is_cooldown = false
		$MuzzleFire.hide()

	# TODO: Focus Feature
	## 100 focus = max_spread_modifier; 0 focus = min_spread_modifier
	#spread_modifier = max_spread_modifier - (max_spread_modifier - min_spread_modifier) * Global.player_node.focus
#
func _on_cooldown_timer_finish() -> void:
	is_cooldown = false

func shoot_single() -> void:
	var new_bullet = create_bullet()
	get_tree().root.add_child.call_deferred(new_bullet)

func shoot_volley() -> void:
	var new_bullet
	var volley_spread = PI * spread_modifier # PI = 180°
	var rotation_step = volley_spread / maxi(1, bullet_amount - 1)
	for i in bullet_amount:
		new_bullet = create_bullet()
		new_bullet.position.y += (volley_spawn_gap*(bullet_amount-1-2*i))/2
		# TODO: calculate the crossover point and add some sort of particle effect
		# or even increase damage (slightly)
		if is_spread_reverse: new_bullet.rotation = -volley_spread/2 + rotation_step * i
		else: new_bullet.rotation = volley_spread/2 - rotation_step * i
		# Adjust rotation to match BulletSpawner rotation
		new_bullet.rotation += global_rotation
		get_tree().root.add_child.call_deferred(new_bullet)

func create_bullet() -> Node:
	var bullet = bullet_scene.instantiate()
	bullet.position = global_position
	bullet.rotation = global_rotation
	return bullet

# TODO: Aimed Bullets Feature
#func rotate_towards_enemy() -> void:
	#var enemy_direction_vector = target_enemy.global_position - global_position
	#rotation = Vector2.RIGHT.angle_to(enemy_direction_vector)
