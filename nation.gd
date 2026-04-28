class_name Nation extends Object

var id: int
var population: float = 0.0
var cells: Array[int] = [] # the cells which it owns stored as ids

func _init(_id: int) -> void:
	id = _id

func update() -> void:
	population = 0.0
	for cell_id in cells:
		population += MapManager.cells[cell_id].population
	
