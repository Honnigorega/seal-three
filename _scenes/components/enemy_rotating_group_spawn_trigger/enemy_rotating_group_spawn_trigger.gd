@tool
extends VisibleOnScreenNotifier2D

@export var spawn_direction: Global.SpawnDirection = Global.SpawnDirection.RIGHT:
	set(value):
		spawn_direction = value
		_update_sprites_position()

@export var enemy_group: Array[EnemyGroupMember] = []
# Used to check for changes in the array, to then update sprites
var enemy_group_tmp = enemy_group

## Brain chip to be used for behavior instructions
@export var brain_chip: BrainChip = BrainChip.new()

# TODO: Implement center enemy
#@export var center_enemy: Global.Enemy

# Inside which range will the group be spread, 2 * PI being 360°
@export var group_spread := 2 * PI:
	set(value):
		group_spread = value
		_update_sprites()
		_update_sprites_position()
# How big is the radius for the spread
@export var group_radius := 40.0:
	set(value):
		group_radius = value
		_update_sprites()
		_update_sprites_position()
@export var rotation_speed := 50:
	set(value):
		rotation_speed = value
		rotation_modifier = 0.01 * value/50
@onready var rotation_modifier := 0.01 * rotation_speed/50
@export var rotate_in_editor := false
@export var clockwise := true:
	set(value):
		clockwise = value
		rotation_direction = 1 if value else -1
@onready var rotation_direction := 1 if clockwise else -1

var rotating_group_scene := load("res://_scenes/enemy/rotating_group/rotating_group.tscn")

func _ready() -> void:
	if !Engine.is_editor_hint():
		screen_entered.connect(_on_screen_entered)
		$Sprites.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#if Engine.is_editor_hint():
	if enemy_group_tmp != enemy_group:
		# Update sprites on group changes
		enemy_group_tmp = enemy_group
		_update_sprites()
		_update_sprites_position()
	if rotate_in_editor && Engine.is_editor_hint():
		$Sprites.rotation += rotation_modifier * rotation_direction
		for child in $Sprites.get_children():
			child.global_rotation = 0.0

func _update_sprites() -> void:
	print("update sprites")
	# Remove existing sprites
	for child in $Sprites.get_children():
		child.free()
	
	# Update sprites
	var rotation_step := group_spread / enemy_group.size()
	for i in enemy_group.size():
		if !enemy_group[i]: continue
		var new_sprite := Sprite2D.new()
		new_sprite.texture = Global.enemy_sprite_dict[enemy_group[i].type]
		new_sprite.position = Vector2(group_radius * cos(rotation_step * i), group_radius * sin(rotation_step * i))
		$Sprites.add_child(new_sprite)

func _update_sprites_position() -> void:
	var all_sprites := $Sprites.get_children()
	if all_sprites.size() <= 0: return
	var largest_size: Vector2 = all_sprites[0].get_rect().size
	for sprite in all_sprites:
		if sprite.get_rect().size > largest_size: largest_size = sprite.get_rect().size
	match spawn_direction:
		Global.SpawnDirection.TOP:
			$Sprites.position = Vector2(0,-group_radius - largest_size.y)
		Global.SpawnDirection.BOTTOM:
			$Sprites.position = Vector2(0,group_radius + largest_size.y)
		Global.SpawnDirection.LEFT:
			$Sprites.position = Vector2.ZERO
			$Sprites.global_position.x = - group_radius - largest_size.x
		Global.SpawnDirection.RIGHT:
			$Sprites.position = Vector2(group_radius + largest_size.x,0)
		_:
			$Sprites.position = Vector2(group_radius + largest_size.x,0)

func _on_screen_entered() -> void:
	var new_rotating_group: RotatingGroup = rotating_group_scene.instantiate()
	new_rotating_group.position = $Sprites.global_position
	new_rotating_group.enemy_group = enemy_group
	new_rotating_group.group_spread = group_spread
	new_rotating_group.group_radius = group_radius
	new_rotating_group.rotation_modifier = rotation_modifier
	new_rotating_group.rotation_direction = rotation_direction

	var enemy_brain = new_rotating_group.get_node_or_null("Brain")
	if enemy_brain && brain_chip:
		enemy_brain.brain_chip = brain_chip
	get_tree().root.add_child(new_rotating_group)
