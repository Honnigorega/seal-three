extends Node

@export var retreat_speed := 300.0
@export var leave_angle := 1.0
@export var leave_angle_weight := -0.0035

@onready var program: Array[Variant] = [
	{ "Move": { "Angle": 1.0, "Speed": 450.0 } },
	{ "WaitDistance": 100 },
	{ "ChangeSpeed": { "To": 10.0, "Weight": -10.0 } },
	{ "WaitTime": 0.4 },
	{ "Shoot": Global.BULLET_SPAWNER_ACTION.TRIGGER },
	{ "WaitTime": 0.4 },
	{ "Move": { "Angle": 1.5, "Speed": 10.0 } },
	{ "ChangeSpeed": { "To": retreat_speed, "Weight": 20.0 } },
	{ "ChangeAngle": { "To": leave_angle, "Weight": leave_angle_weight } },
]
