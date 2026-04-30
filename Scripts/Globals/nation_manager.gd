extends Node

var nations: Array[Nation] = [Nation.new(0)]

var nation0_color: Color = Color(1, 0, 0, 0.25)
var nation1_color: Color = Color(0, 1, 0, 0.25)
var nation2_color: Color = Color(0, 0, 1, 0.25)

func _ready() -> void:
	TimeManager.day_passed.connect(tick)

func update_nations() -> void:
	for nation in nations:
		nation.update()

func tick(_day: int) -> void:
	update_nations()
