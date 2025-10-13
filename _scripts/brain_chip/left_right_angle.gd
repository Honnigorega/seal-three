extends Node

@export var retreat_speed := 250.0

@export var leave_angle := 0.0
@export var leave_angle_weight := -0.005

@onready var program: Array[Variant] = [
	{ "Move": { "Angle": 1.0, "Speed": 400.0 } },
	{ "WaitDistance": 200 },
	{ "ChangeSpeed": { "To": 50.0, "Weight": -10.0 } },
	{ "WaitTime": 0.4 },
	{ "Shoot": Global.BULLET_SPAWNER_ACTION.TRIGGER },
	{ "WaitTime": 0.4 },
	{"ChangeAngle": { "To": leave_angle, "Weight": leave_angle_weight } },
	{ "ChangeSpeed": { "To": retreat_speed, "Weight": 20.0 } },
	{ "WaitTime": 1.5 },
	{ "Shoot": Global.BULLET_SPAWNER_ACTION.TRIGGER },
]
