extends Node

var population: PackedFloat32Array

const width: int = 256
const height: int = 256

var cell_count: int # how many cells exist

var tilemaplayer: TileMapLayer

var updating_cells: bool = false
var cell_index: int = 0
const CHUNK_SIZE: int = 200000

var noise: FastNoiseLite = FastNoiseLite.new()

func initialize() -> void:
	cell_count = width * height
	
	tilemaplayer = get_node("/root/main/TileMapLayer")
	
	population = PackedFloat32Array()
	
	population.resize(cell_count)
	
	noise.seed = randi_range(0, pow(2, 31)-1)
	noise.frequency = 0.005
	noise.fractal_octaves = 24
	
	for i in range(cell_count):
		population[i] = 100.0
		
		var x: int = i % width
		var y: int = i / width
		
		var pos_2d: Vector2i = Vector2i(x, y)
		var value: float = (noise.get_noise_2d(x, y) + 1.0) * 0.5
		var atlas: Vector2i = Vector2i.ZERO if value < 0.45 else Vector2i(1, 0)
		
		tilemaplayer.set_cell(pos_2d, 0, atlas)
		
	TimeManager.day_passed.connect(tick)


func _ready() -> void:
	initialize()

func _process(_delta: float) -> void:
	if not updating_cells: return
	
	if cell_index >= cell_count:
		updating_cells = false
		print("Finished Updating Cells")
		return
	
	var cells_left: int = cell_count - cell_index
	
	var count: int = min(CHUNK_SIZE, cells_left)
	var end_index: int = cell_index + count
	
	for i in range(cell_index, end_index):
		population[i] *= 1.005
	
	cell_index = end_index

func tick(_day: int) -> void:
	if updating_cells:
		print("New day started before cells had been updated for last day; maybe increase chunk size?")
	
	updating_cells = true
	cell_index = 0
	
	print("Started Updating Cells")
