class_name HealthComponent
extends Node

signal death

## Maximum health value
@export var max_health: int = 1

## Current health value; Emits death signal on reaching 0 or below
@onready var health := max_health:
	set(value):
		health = value
		if health <= 0:
			death.emit()

## Reduce health by a specified value
func reduce_health(value: int) -> void:
	health -= value
