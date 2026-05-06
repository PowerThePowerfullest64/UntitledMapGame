class_name Nation extends Object

var title: String
var id: int
var population: float = 0.0
var cells: Array[int] = [] # the cells which it owns stored as ids
var area: int = 0
var capital: float = 100_000.0
var tax_rate: float = 0.001 # capital per person per day

func _init(_title: String, _id: int) -> void:
	title = _title
	id = _id

func add_cell(cell_id: int) -> bool:
	if cells.has(cell_id): return false
	if not MapManager.ownable[MapManager.terrain_type[cell_id]]: return false # water cannot be claimed
	
	var owner_id: int = MapManager.owner_id[cell_id]
	
	if owner_id == -1: remove_cell(cell_id)
	
	if owner_id != -1:
		NationManager.nations[owner_id].remove_cell(cell_id)
	
	cells.append(cell_id)
	area += 1
	MapManager.owner_id[cell_id] = id
	
	NationManager.tilemaplayer.set_cell(MapManager.idx_to_pos(cell_id), 0, Vector2i(id, 0))
	
	print("Added cell to " + title)
	
	return true

func remove_cell(cell_id: int) -> bool:
	if not cells.has(cell_id): return false
	
	cells.erase(cell_id)
	area -= 1
	MapManager.owner_id[cell_id] = -1
	
	NationManager.tilemaplayer.set_cell(MapManager.idx_to_pos(cell_id), 0, Vector2i(3, 0))
	
	print("Removed cell from " + title)
	
	return true

func update() -> void:
	population = 0.0
	for cell_id in cells:
		population += MapManager.population[cell_id]
	
	var income: float = 0.0
	for cell_id in cells:
		income += MapManager.population[cell_id] * tax_rate
	var expenses: float = 0.0
	capital += income - expenses
