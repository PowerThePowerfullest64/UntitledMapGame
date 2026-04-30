class_name Nation extends Object

var id: int
var population: float = 0.0
var cells: Array[int] = [] # the cells which it owns stored as ids
var area: int = 0

func _init(_id: int) -> void:
	id = _id

func add_cell(cell_id: int) -> bool:
	if cells.has(cell_id): return false
	
	cells.append(cell_id)
	area += 1
	MapManager.owner_id[cell_id] = id
	
	return true

func remove_cell(cell_id: int) -> bool:
	if not cells.has(cell_id): return false
	
	cells.erase(cell_id)
	area -= 1
	MapManager.owner_id[cell_id] = -1
	
	return true

func update() -> void:
	population = 0.0
	for cell_id in cells:
		population += MapManager.cells[cell_id].population
	
