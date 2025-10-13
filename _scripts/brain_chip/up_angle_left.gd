extends Node

var program: Array[Variant] = [
	{ "Move": { "Angle": 1.5, "Speed": 400.0 } },
	{ "WaitDistance": 200 },
	{ "ChangeSpeed": { "To": 20.0, "Weight": -10.0 } },
	{ "WaitTime": 0.4 },
	{ "Shoot": Global.BULLET_SPAWNER_ACTION.TRIGGER },
	{ "WaitTime": 0.4 },
	{ "ChangeAngle": { "To": 1.0, "Weight": -0.005 } },
	{ "ChangeSpeed": { "To": 300.0, "Weight": 20.0 } },
]
