extends Node

# A simple movement component

## Node that is to be moved by using this component
@export var movable_node: Node2D
## Names of the Input actions that need to be defined in Project Settings
@export var input_actions := ["move_left", "move_right", "move_up", "move_down"]
## Can the movable node move outside the viewport bounds
@export var restrict_movement_to_viewport := true
@onready var viewport_size := movable_node.get_viewport_rect().size

## Speed of the movement
@export var speed := 300.0

enum InputAction {
	MOVE_LEFT,
	MOVE_RIGHT,
	MOVE_UP,
	MOVE_DOWN
}

var input_dict = {
	InputAction.MOVE_LEFT: input_actions[0],
	InputAction.MOVE_RIGHT: input_actions[1],
	InputAction.MOVE_UP: input_actions[2],
	InputAction.MOVE_DOWN: input_actions[3],
}

var velocity := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Check if a movable node is provided
	assert(movable_node, "ERROR: You must provide a movable_node Node2D.");
	# Check if the necessary input actions are mapped
	for input_action in input_actions:
		assert(InputMap.has_action(input_action), "ERROR: You must provide a '%s' Input Action." % input_action)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed(input_dict[InputAction.MOVE_LEFT]):
		velocity.x -= 1
	if Input.is_action_pressed(input_dict[InputAction.MOVE_RIGHT]):
		velocity.x += 1
	if Input.is_action_pressed(input_dict[InputAction.MOVE_UP]):
		velocity.y -= 1
	if Input.is_action_pressed(input_dict[InputAction.MOVE_DOWN]):
		velocity.y += 1
	
	velocity = velocity.normalized() * speed
	movable_node.position += velocity * delta

	if restrict_movement_to_viewport:
	# Movable node cannot move outside the viewport
		movable_node.position = movable_node.position.clamp(
			Vector2.ZERO,
			Vector2(viewport_size.x, viewport_size.y)
		)
	
