class_name TrigonometricInstruction
extends Instruction

const TYPE: InstructionType = InstructionType.TRIGONOMETRIC

@export var trg_function := Global.TrigonometricFunction.SIN
@export var amp := 150.0
@export var freq := 0.015
@export var phase := 0.0
## LEFT: 1.0, RIGHT: 0.0, UP: 1.5, DOWN: 0.5
@export var angle := 1.0
@export var speed := 100.0
