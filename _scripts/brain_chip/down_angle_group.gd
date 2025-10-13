extends Node

var program: Array[Variant] = [
	{ "Move": { "Angle": 0.75, "Speed": 200.0 } },
	{ "ChangeAngle": { "To": 0.25, "Weight": -0.0015 } },
	{ "WaitDistance": randi_range(100, 350) },
	{ "Shoot": Global.BULLET_SPAWNER_ACTION.TRIGGER },
]
