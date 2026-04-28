extends Node

var nations: Array[Nation] = [Nation.new(0)]

func _ready() -> void:
	TimeManager.connect("day_passed", tick)

func update_nations() -> void:
	for nation in nations:
		nation.update()

func tick() -> void:
	update_nations()
