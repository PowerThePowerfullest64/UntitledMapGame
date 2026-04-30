extends Node

var day: int = 1

var accumulator: float = 0.0
var tps: float = 0.0
var tick_duration: float = 0.0

signal day_passed(day: int)

const SPEED1: float = 0.5
const SPEED2: float = 2.0
const SPEED3: float = 8.0
const SPEED4: float = 24.0

func set_tps(_tps: float) -> void:
	tps = _tps
	tick_duration = 1.0 / tps

func _ready() -> void:
	set_tps(SPEED1)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("speed1"): set_tps(SPEED1)
	if Input.is_action_just_pressed("speed2"): set_tps(SPEED2)
	if Input.is_action_just_pressed("speed3"): set_tps(SPEED3)
	if Input.is_action_just_pressed("speed4"): set_tps(SPEED4)
	
	accumulator += delta
	
	while accumulator >= tick_duration:
		day += 1
		day_passed.emit(day)
		
		accumulator -= tick_duration
