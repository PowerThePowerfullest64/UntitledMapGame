extends Node

var cells: Array[Cell] = []

const width: int = 64
const height: int = 64

var cell_count: int # how many cells exist

var tilemaplayer: TileMapLayer

func initialize() -> void:
	cell_count = width * height
	
	tilemaplayer = get_node("/root/main/TileMapLayer")
	
	for i in range(cell_count):
		cells.append(Cell.new(i))
		
		var x: int = i % width
		var y: int = int(float(i) / float(width)) # changed it to remove the warning :(
		
		var pos_2d: Vector2i = Vector2i(x, y)
		
		tilemaplayer.set_cell(pos_2d, 0, Vector2i.ZERO)
		
	TimeManager.day_passed.connect(tick)
	
	
func update_cells() -> void:
	for i in range(cell_count):
		cells[i].update()

func _ready() -> void:
	initialize()

func tick(_day: int) -> void:
	update_cells()
	print("Updated Cells!")
