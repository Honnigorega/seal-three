class_name ChangeSpeedInstruction
extends Instruction

const TYPE: InstructionType = InstructionType.CHANGE_SPEED

## To which speed current speed will be changed
@export var to: float = 0.0
## How quickly will the speed be changed; The more weight the faster
@export var weight: float = 1.0
