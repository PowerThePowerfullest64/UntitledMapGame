extends Node

var day: int = 1

var accumulator: float = 0.0
var tps: float = 0.0
var tick_duration: float = 0.0

signal day_passed

func set_tps(_tps: float) -> void:
	tps = _tps
	tick_duration = 1.0 / tps

func _ready() -> void:
	set_tps(1.0)

func _process(delta: float) -> void:
	accumulator += delta
	
	while accumulator >= tick_duration:
		day_passed.emit()
		
		accumulator -= tick_duration
