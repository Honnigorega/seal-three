class_name Hitbox
extends Area2D

# A simple hitbox component that checks for collisions with
# another Area2D that is part of the specified group

signal hit(area: Area2D)

@onready var collision_shape := $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Check required components
	assert(collision_shape, "ERROR: You must provide a CollisionShape2D child.")
	assert(get_groups().size() > 0, "ERROR: You must provide at least 1 group.")
	
	# Signal handlers
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	for group in get_groups():
		if area.is_in_group(group):
			hit.emit(area)
