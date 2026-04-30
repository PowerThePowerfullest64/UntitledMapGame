extends Node

var nations: Array[Nation] = [Nation.new(0)]

func _ready() -> void:
	TimeManager.day_passed.connect(tick)

func update_nations() -> void:
	for nation in nations:
		nation.update()

func tick(_day: int) -> void:
	update_nations()
