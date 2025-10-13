extends Node

var program: Array[Variant] = [
	{ "Move": { "Angle": 1.5, "Speed": 400.0 } },
	{ "WaitDistance": 100 },
	{ "ChangeSpeed": { "To": 0.0, "Weight": -10.0 } },
	{ "WaitTime": 0.4 },
	{ "Shoot": Global.BULLET_SPAWNER_ACTION.TRIGGER },
	{ "WaitTime": 0.4 },
	{ "Move": { "Angle": 1.0, "Speed": 0.0 } },
	{ "ChangeSpeed": { "To": 250.0, "Weight": 20.0 } },
]
