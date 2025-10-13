class_name MoveInstruction
extends Instruction

const TYPE: InstructionType = InstructionType.MOVE

## LEFT: 1.0, RIGHT: 0.0, UP: 1.5, DOWN: 0.5
@export var angle: float = 1.0
@export var speed: float = 100.0
