@abstract
class_name Instruction
extends Resource
# This class bundles all types of instructions

enum InstructionType {
	MOVE,
	TRIGONOMETRIC,
	WAIT_DISTANCE,
	WAIT_TIME,
	SHOOT,
	CHANGE_SPEED,
	CHANGE_ANGLE,
	REPEAT
}
