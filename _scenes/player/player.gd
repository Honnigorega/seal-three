extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.player_node = self # Set a global reference to the player node
	if find_child("Hitbox"): $Hitbox.hit.connect(_on_hit)
	if find_child("Hurtbox"): $Hurtbox.hit.connect(_on_hit)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func _on_hit() -> void:
	print("Game Over")
