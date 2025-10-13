extends Node

@export var retreat_speed := 300.0

@onready var program: Array[Variant] = [
	{ "Move": { "Angle": 1.0, "Speed": 450.0 } },
	{ "WaitDistance": 100 },
	{ "ChangeSpeed": { "To": 50.0, "Weight": -10.0 } },
	{ "WaitTime": 0.4 },
	{ "Shoot": Global.BULLET_SPAWNER_ACTION.TRIGGER },
	{ "WaitTime": 0.4 },
	{ "ChangeSpeed": { "To": retreat_speed, "Weight": 20.0 } },
	{ "ChangeAngle": { "To": 1.25, "Weight": 0.005 } },
]
