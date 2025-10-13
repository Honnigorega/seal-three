extends Area2D

# A simple hitbox component that checks for collisions with
# another Area2D that is part of the specified group

signal hit

@export var collision_group: String

@onready var collision_shape := $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(collision_shape, "ERROR: You must provide a CollisionShape2D child.")
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group(collision_group):
		hit.emit()
