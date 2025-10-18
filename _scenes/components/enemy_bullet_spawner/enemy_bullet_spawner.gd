extends Node2D
class_name EnemyBulletSpawner

## Gets emitted with the first bullet pattern spawn
signal first_shot

## Bullet patterns to choose from
enum BulletPattern {
	SINGLE,
	VOLLEY
}

## How the spawner should be used from the outside
enum Actions {
	ACTIVATE,
	TRIGGER
}

## Bullet scene that will be spawned
@export var bullet_scene: PackedScene 

## Is the spawner automatically creating bullets
@export var active = false
## Bullet pattern
@export var bullet_pattern: BulletPattern = BulletPattern.SINGLE
## Shoots the selected pattern only once
@export var one_shot = false

@export_group("Bullet")
## Custom bullet speed. Will override the bullet's default value
@export var bullet_speed := 0.0
## Will pick a random value between -value and value
@export var bullet_speed_variation := 0.0
## How many bullets per shot / volley
@export var bullet_amount := 1
## 100 to 0 %
@export var bullet_accuracy = 100
## 0% accuracy value
@export var max_random_spread = 0.5

@export_group("All")
## Do the bullets from this spawner get cancelled on death?
@export var bullet_cancel_on_death := false
## Do the bullets drop score upon cancel
@export var bullets_drop_score := true

# TODO: Player destructible bullets
## Can the bullet be destroyed by the player's weapon
## The player weapon/bullet also needs to be able to destroy
#@export var can_be_destroyed := false

## Does the bullet target the player on shot
@export var target_player := false
## Time in seconds between each bullet
@export var fire_rate := 0.5
## Time in seconds between each discharge
@export var shot_frequency := 2.0
## Will pick a random value between -value and value
@export var shot_frequency_variation := 0.0
## Start delay in seconds [br]
## Will be added on top of Shot Frequency for the first discharge
@export var start_delay := 0.0

@export_group("Volley")
## How many volleys per shot [br]
## The frequency is determined by the Fire Rate
@export var volley_amount := 1
## 0.0 = 0°, 2.0 = 360° [br]
## Example: 1.0 spreads the bullets per volley evenly among a 180° angle
@export var volley_spread_modifier := 1.0
## Vertical gap between bullet exit points in px
@export var volley_gap := 0.0
## Delay in seconds between individual bullets in a volley
@export var volley_bullet_delay := 0.0
## As per default, bullets start spawning from the bottom up [br]
## false: bottom -> top, true: top -> bottom
@export var volley_reverse := false

@export_group("Rotation")
@export var is_rotating := false
## Rotate either clockwise or counter-clockwise
@export var clockwise := true
## How fast does the spawner rotates
@export var rotation_speed := 0.0

var elapsed_time := 0.0
var frequency = 0.0
var has_shot := false
var is_triggered := false

var on_screen = false

#@onready var health_node = $"../Health"
@onready var health_node = owner.get_node_or_null("Health")

func _ready() -> void:
	assert(bullet_scene, "ERROR: You must provide a bullet_scene.")
	$VisibleOnScreenNotifier2D.screen_entered.connect(_on_screen_entered)
	$VisibleOnScreenNotifier2D.screen_exited.connect(_on_screen_exited)
	# Hide the Sprite, as it is for testing and configuration purposes only
	$Sprite2D.hide()
	# Calculate the shot frequency together with frequency variation
	frequency = calculate_frequency()
	if health_node:
		health_node.killed.connect(func(): queue_free())

func _process(delta: float) -> void:
	if target_player:
		rotate_towards_player()
	
	if !on_screen || !active: return
	if one_shot && has_shot: return
	
	delta *= Global.timescale
	elapsed_time += delta
	
	# Wait for start_delay
	if start_delay > 0:
		start_delay -= delta
		return
	
	if is_rotating:
		if clockwise: rotation += rotation_speed * delta
		else: rotation -= rotation_speed * delta
	
	if !has_shot: frequency = 0
	
	if elapsed_time >= frequency:
		elapsed_time = 0
		frequency = calculate_frequency()
		match bullet_pattern:
			BulletPattern.SINGLE: shoot()
			BulletPattern.VOLLEY: shoot_volley()
		if !has_shot:
			first_shot.emit()
			has_shot = true

func rotate_towards_player() -> void:
	if !Global.player_node: return
	var player_direction_vector = Global.player_node.get_node("Hitbox").global_position - global_position
	global_rotation = Vector2.LEFT.angle_to(player_direction_vector)

func calculate_frequency() -> float:
	return randf_range(shot_frequency-shot_frequency_variation, shot_frequency+shot_frequency_variation)

func create_bullet() -> Node:
	var new_bullet = bullet_scene.instantiate()
	if bullet_speed != 0:
		new_bullet.get_node("BulletComponent").speed = bullet_speed
	new_bullet.get_node("BulletComponent").speed_variation = bullet_speed_variation
	new_bullet.get_node("BulletComponent").accuracy = bullet_accuracy
	new_bullet.get_node("BulletComponent").max_random_spread = max_random_spread
	new_bullet.position = global_position
	return new_bullet

func shoot() -> void:
	var new_bullet
	for i in bullet_amount:
		# Stop spawning bullets if the spawner isn't active nor has been triggered
		if !active && !is_triggered: break
		new_bullet = create_bullet()
		# Adjust rotation to match BulletSpawner rotation
		new_bullet.rotation += global_rotation
		# TODO: Bullet cancel feature (probably define it for individual projectiles)
		#if bullet_cancel_on_death: $Bullets.add_child.call_deferred(new_bullet)
		#else: get_tree().root.add_child.call_deferred(new_bullet)
		
		get_tree().root.add_child.call_deferred(new_bullet)
		
		# TODO: dont create a timer every time. reuse a common timer
		await get_tree().create_timer(fire_rate).timeout
	if is_triggered: is_triggered = false

func shoot_volley() -> void:
	var new_bullet
	var volley_spread = PI * volley_spread_modifier # default is 180 degrees
	var rotation_step = volley_spread / maxi(1, bullet_amount - 1)

	for volley in volley_amount:
		# Stop spawning volleys if the spawner isn't active nor has been triggered
		if !active && !is_triggered: break
		for i in bullet_amount:
			# Stop spawning bullets if the spawner isn't active nor has been triggered
			if !active && !is_triggered: break
			new_bullet = create_bullet()
			if !volley_reverse:
				new_bullet.position.y += (volley_gap*(bullet_amount-1-2*i))/2
				new_bullet.rotation = -volley_spread/2 + rotation_step * i
			else:
				new_bullet.position.y -= (volley_gap*(bullet_amount-1-2*i))/2
				new_bullet.rotation = volley_spread/2 - rotation_step * i
			# Adjust rotation to match BulletSpawner rotation
			new_bullet.rotation += global_rotation
			
			# TODO: Bullet cancel feature (probably define it for individual projectiles)
			#if bullet_cancel_on_death: $Bullets.add_child.call_deferred(new_bullet)
			#else: get_tree().root.add_child.call_deferred(new_bullet)
			
			get_tree().root.add_child.call_deferred(new_bullet)
			
			# TODO: same here... is it bad practice to use create_timer this way?
			await get_tree().create_timer(volley_bullet_delay).timeout
		await get_tree().create_timer(fire_rate).timeout
	if is_triggered: is_triggered = false

## Trigger the Spawner once manually
func trigger() -> void:
	is_triggered = true
	match bullet_pattern:
		BulletPattern.SINGLE: shoot()
		BulletPattern.VOLLEY: shoot_volley()
	if !has_shot:
		first_shot.emit()
		has_shot = true

# TODO: Bullet cancel feature
#func cancel_bullets() -> void:
	#for bullet in $Bullets.get_children():
		#bullet.despawn(bullets_drop_score)

func _on_screen_entered() -> void:
	on_screen = true

func _on_screen_exited() -> void:
	on_screen = false
