extends Node

var day: int = 1

var accumulator: float = 0.0
var tps: float = 0.0
var tick_duration: float = 0.0
const TPS_RATE: float = 0.02 # how fast tps interpolates to target tps
var target_tps: float = 0.0

var paused: bool = false

signal day_passed(day: int)

const SPEED1: float = 0.5
const SPEED2: float = 2.0
const SPEED3: float = 5.0
const SPEED4: float = 16.0

func set_target_tps(_target_tps: float) -> void:
	target_tps = _target_tps

func set_tps(_tps: float) -> void:
	tps = _tps
	
	if tps == 0.0:
		tick_duration = INF
	else:
		tick_duration = 1.0 / tps

func _ready() -> void:
	set_target_tps(SPEED1)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_pause"):
		paused = not paused
	
	if paused:
		set_tps(0.0)
	else:
		set_tps(lerp(tps, target_tps, TPS_RATE))
	
	if Input.is_action_just_pressed("speed1"): set_target_tps(SPEED1)
	if Input.is_action_just_pressed("speed2"): set_target_tps(SPEED2)
	if Input.is_action_just_pressed("speed3"): set_target_tps(SPEED3)
	if Input.is_action_just_pressed("speed4"): set_target_tps(SPEED4)
	
	accumulator += delta
	
	while accumulator >= tick_duration:
		day += 1
		day_passed.emit(day)
		
		accumulator -= tick_duration
