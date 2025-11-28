class_name Brain
extends Node

# Brain component that interpretes instructions based on a provided brain_chip
# When referring to "owner", it's the root node of the tree this brain is attached to

## Brain chip that contains instructions
## Can be set from the spawner node, or directly for an enemy as a default
@export var brain_chip: BrainChip
## Default angle the unit will move in
@export var default_angle := 0.0
## Default speed the unit will move by
@export var default_speed := 0.0

## Instructions are read from the brain chip
var brain_instructions: Array[Instruction] = []
## Used as buffer inbetween instructions
var wait_timer: Timer

## Current state/index of instructions
var state := 0

## Velocity, angle and speed of the owner's movement
var velocity := Vector2.ZERO
@onready var angle := default_angle
@onready var speed := default_speed

## Speed and angle value transitions
## The more weight the faster the transition
var to_speed = null
var to_angle = null
var speed_weight: float = 1.0
var angle_weight: float = 1.0

## Used for trigonometric movement patterns
var amp := 0.0
var freq := 0.0
var phase := 0.0
var is_sine := false
var is_cos := false

## Used to repeat instruction states
var repeat_from := 0
var repeat_times := -1

@onready var initial_pos: Vector2 = owner.position
@onready var initial_wait_pos: Vector2 = Vector2.INF
@onready var bullet_spawners = owner.get_node_or_null("BulletSpawners")

func _enter_tree() -> void:
	if !brain_chip: return
	brain_instructions = brain_chip.instructions

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_wait_timer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if to_speed != null && speed_weight != 0.0:
		speed += speed_weight
		if abs(to_speed - speed) < abs(speed_weight):
			speed = to_speed
			to_speed = null

	if to_angle != null && angle_weight != 0.0:
		angle += angle_weight
		if abs(to_angle - angle) < abs(angle_weight):
			angle = to_angle
			to_angle = null
	
	velocity = Vector2.from_angle(PI * angle)
	owner.position += velocity.normalized() * speed * delta

	if is_sine:
		owner.position.y = amp * sin(freq * owner.position.x + phase) + initial_pos.y
	if is_cos:
		owner.position.y = amp * cos(freq * owner.position.x + phase) + initial_pos.y
	
	if state >= brain_instructions.size(): return
	match brain_instructions[state].TYPE:
		# Move
		Instruction.InstructionType.MOVE:
			angle = brain_instructions[state].angle
			speed = brain_instructions[state].speed
			next_state()
		# Trigonometric
		Instruction.InstructionType.TRIGONOMETRIC:
			initial_pos = owner.position
			amp = brain_instructions[state].amp
			freq = brain_instructions[state].freq
			phase = brain_instructions[state].phase
			angle = brain_instructions[state].angle
			speed = brain_instructions[state].speed
			is_sine = brain_instructions[state].trg_function == Global.TrigonometricFunction.SIN
			is_cos = !is_sine
			next_state()
		# Shoot
		Instruction.InstructionType.SHOOT:
			if !bullet_spawners:
				next_state()
				return
			for spawner in bullet_spawners.get_children():
				if brain_instructions[state].action_type == EnemyBulletSpawner.Actions.TRIGGER:
					spawner.trigger()
				else:
					spawner.active = true
			next_state()
		# Wait Distance
		Instruction.InstructionType.WAIT_DISTANCE:
			if initial_wait_pos == Vector2.INF:
				initial_wait_pos = owner.position
			if initial_wait_pos.distance_to(owner.position) >= brain_instructions[state].distance:
				initial_wait_pos = Vector2.INF
				next_state()
		# Wait Time
		Instruction.InstructionType.WAIT_TIME:
			if brain_instructions[state].time <= 0:
				next_state()
				return
			if wait_timer.is_stopped():
				wait_timer.wait_time = brain_instructions[state].time
				wait_timer.start()
		# Change Speed
		Instruction.InstructionType.CHANGE_SPEED:
			to_speed = brain_instructions[state].to
			speed_weight = brain_instructions[state].weight
			next_state()
		# Change Angle
		Instruction.InstructionType.CHANGE_ANGLE:
			to_angle = brain_instructions[state].to
			angle_weight = brain_instructions[state].weight
			next_state()
	
## Timer that will be used with WaitTimeInstruction
func create_wait_timer() -> void:
	wait_timer = Timer.new()
	wait_timer.one_shot = true
	self.add_child(wait_timer)
	wait_timer.timeout.connect(next_state)

## Increment Instruction state
func next_state() -> void:
	state += 1

# @TODO: Create Repeat Instruction Interpreter

		#"Repeat":
			#if brain_instructions[state]["Repeat"]["From"]:
				#repeat_from = brain_instructions[state]["Repeat"]["From"]
			#if brain_instructions[state]["Repeat"]["Times"] && repeat_times < 0:
				#repeat_times = brain_instructions[state]["Repeat"]["Times"]
			#if repeat_times > 0:
				#repeat_times -= 1
				#state = repeat_from
			#else:
				#repeat_times = -1
				#next_state()
