class_name ChangeAngleInstruction
extends Instruction

const TYPE: InstructionType = InstructionType.CHANGE_ANGLE

## To which angle current angle will be changed
@export var to: float = 0.0
## How quickly will the angle be changed; The more weight the faster
@export var weight: float = 1.0
