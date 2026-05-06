extends Node

var nations: Array[Nation] = [Nation.new("Empire of Eldia", 0), Nation.new("Nation1", 1), Nation.new("Nation2", 2)]

var tilemaplayer: TileMapLayer

func _ready() -> void:
	tilemaplayer = get_node("/root/main/PoliticalLayer")
	
	TimeManager.day_passed.connect(tick)
	
	for i in range(192*32): nations[0].add_cell(i)

func update_nations() -> void:
	for nation in nations:
		nation.update()

func tick(_day: int) -> void:
	update_nations()

func _process(delta: float) -> void:
	pass
