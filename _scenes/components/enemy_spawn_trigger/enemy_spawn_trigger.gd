@tool
extends VisibleOnScreenNotifier2D

@export var spawn_direction: Global.SpawnDirection = Global.SpawnDirection.RIGHT:
	set(value):
		spawn_direction = value
		_update_sprite_position()

## Which type of enemy will be spawned
@export var enemy_type: Global.Enemy = Global.Enemy.LILY_OF_THE_VALLEY:
	set(value):
		enemy_type = value
		_update_sprite()
		_update_sprite_position()

## Brain chip to be used for behavior instructions
@export var brain_chip: BrainChip = BrainChip.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#_update_sprite()
	if !Engine.is_editor_hint():
		screen_entered.connect(_on_screen_entered)
		$Sprite.hide()

func _on_screen_entered() -> void:
	# Spawn the specified enemy type
	_spawn_enemy_by_type(enemy_type)
 
func _spawn_enemy_by_type(type: Global.Enemy) -> void:
	var enemy = Global.enemy_scene_dict[type].instantiate()
	enemy.position = $Sprite.global_position
	var enemy_brain = enemy.get_node_or_null("Brain")
	if enemy_brain && brain_chip:
		enemy_brain.brain_chip = brain_chip
	get_tree().root.add_child(enemy)

func _update_sprite() -> void:
	$Sprite.texture = Global.enemy_sprite_dict[enemy_type]

func _update_sprite_position() -> void:
	match spawn_direction:
		Global.SpawnDirection.TOP:
			$Sprite.position = Vector2(0,-$Sprite.get_rect().size.y)
		Global.SpawnDirection.BOTTOM:
			$Sprite.position = Vector2(0,$Sprite.get_rect().size.y)
		Global.SpawnDirection.LEFT:
			$Sprite.position = Vector2.ZERO
			$Sprite.global_position.x = -$Sprite.get_rect().size.x
		Global.SpawnDirection.RIGHT:
			$Sprite.position = Vector2($Sprite.get_rect().size.x,0)
		_:
			$Sprite.position = Vector2($Sprite.get_rect().size.x,0)
