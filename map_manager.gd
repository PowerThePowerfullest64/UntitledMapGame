extends Node

var cells: Array[Cell] = []

const width: int = 120
const height: int = 67

var cell_count: int # how many cells exist

# for independant update loop
var accumulator: float = 0.0
const TPS: float = 8.0
var tick_duration: float = 0.0

var tilemaplayer: TileMapLayer

func initialize() -> void:
	cell_count = width * height
	tick_duration = 1.0 / TPS
	
	tilemaplayer = get_node("/root/main/TileMapLayer")
	
	for i in range(cell_count):
		cells.append(Cell.new(i))
		
		var x: int = i % width
		var y: int = i / width
		
		var pos_2d: Vector2i = Vector2i(x, y)
		
		tilemaplayer.set_cell(pos_2d, 0, Vector2i.ZERO)
		
	TimeManager.connect("day_passed", tick)
	
	
func update_cells() -> void:
	for i in range(cell_count):
		cells[i].update()

func _ready() -> void:
	initialize()

func tick() -> void:
	update_cells()
	print("Updated Cells!")
