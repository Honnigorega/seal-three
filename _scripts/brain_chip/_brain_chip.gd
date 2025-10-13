# This class is only used to bundle all brain chip resources under BrainChipResource
#@abstract
class_name BrainChip
extends Resource

@export var instructions: Array[Instruction]

# Move -> { "Angle": 1.0, "Speed": speed }
# Trg needs work in the interpreter as well (brain.gd)
# TRIGONOMETRIC -> { trg_function: { "Amplitude": amp, "Frequency": freq, "Phase": phase } },
# WaitTime -> { "WaitTime": 0.4 },
# WaitDistance -> { "WaitDistance": shoot_distance }
