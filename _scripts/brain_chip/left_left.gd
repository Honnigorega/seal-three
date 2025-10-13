extends Node

@export var init_speed := 400.0
@export var exit_speed := 250.0

@onready var program: Array[Variant] = [
	{ "Move": { "Angle": 1.0, "Speed": init_speed } },
	{ "WaitDistance": 150 },
	{ "ChangeSpeed": { "To": 0.0, "Weight": -10.0 } },
	{ "WaitTime": 0.4 },
	{ "Shoot": Global.BULLET_SPAWNER_ACTION.TRIGGER },
	{ "WaitTime": 0.4 },
	{ "ChangeSpeed": { "To": exit_speed, "Weight": 20.0 } },
]
