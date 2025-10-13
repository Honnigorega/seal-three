extends Node

@export var target_node: Node
@export var kill_time := 5.0 ## Time in seconds when to kill the target_node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(target_node, "ERROR: You must provide a target_node.")
	$Timer.timeout.connect(_on_timeout)

	$Timer.start(kill_time)

func _on_timeout() -> void:
	target_node.queue_free()
