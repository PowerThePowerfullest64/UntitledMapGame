extends Node

var population: PackedFloat32Array
var selected: PackedByteArray
var owner_id: PackedInt32Array
var terrain_type: PackedByteArray

var terrain_name: Array[String] = [
	"Water",
	"Grass"
]
var move_speed: Array[float] = [ # for later
	1.5,
	1.0
]
var ownable: Array[bool] = [
	false,
	true
]

const width: int = 192
const height: int = 192

var cell_count: int # how many cells exist

var tilemaplayer: TileMapLayer
var cell_length: int = 16

var updating_cells: bool = false
var cell_index: int = 0
const CHUNK_SIZE: int = 500000 # cells updated per frame: higher = more work in less frames

var noise: FastNoiseLite = FastNoiseLite.new()

var water_atlas: Vector2i = Vector2i(1, 0)
var grass_atlas: Vector2i = Vector2i.ZERO

func initialize() -> void:
	cell_count = width * height
	
	tilemaplayer = get_node("/root/main/TerrainLayer")
	tilemaplayer.scale = Vector2.ONE * cell_length / 16.0 # 16 is default tile size from tileset
	
	population = PackedFloat32Array()
	selected = PackedByteArray()
	owner_id = PackedInt32Array()
	terrain_type = PackedByteArray()
	
	population.resize(cell_count)
	selected.resize(cell_count)
	owner_id.resize(cell_count)
	terrain_type.resize(cell_count)
	
	population.fill(100.0)
	selected.fill(0)
	owner_id.fill(-1)
	terrain_type.fill(0)
	
	noise.seed = randi_range(0, (1 << 63) - 1)
	noise.frequency = 0.01
	noise.fractal_octaves = 24
	
	for i in range(cell_count):
		var x: int = i % width
		var y: int = i / width
		
		var pos_2d: Vector2i = Vector2i(x, y)
		var value: float = (noise.get_noise_2d(x, y) + 1.0) * 0.5
		
		terrain_type[i] = 1 if value > 0.45 else 0
		
		if not ownable[terrain_type[i]]: # in non-ownable terrain, no people live here
			population[i] = 0.0
		
		var atlas: Vector2i = grass_atlas if terrain_type[i] == 1 else water_atlas if terrain_type[i] == 0 else Vector2i.ZERO
		
		tilemaplayer.set_cell(pos_2d, 0, atlas)
		
	TimeManager.day_passed.connect(tick)


func _ready() -> void:
	initialize()

func _process(_delta: float) -> void:
	if not updating_cells: return
	
	if cell_index >= cell_count:
		updating_cells = false
		#print("Finished Updating Cells")
		return
	
	var cells_left: int = cell_count - cell_index
	
	var count: int = min(CHUNK_SIZE, cells_left)
	var end_index: int = cell_index + count
	
	for i in range(cell_index, end_index):
		if terrain_type[i] == 0: # water needs no updating
			continue
		
		var births: float = population[i] * 0.0006
		var deaths: float = population[i] * 0.0005
		population[i] += births - deaths
	
	cell_index = end_index

func tick(_day: int) -> void:
	if updating_cells:
		print("New day started before cells had been updated for last day; maybe increase chunk size?")
	
	updating_cells = true
	cell_index = 0
	
	#print("Started Updating Cells")

func to_map_pos(pos: Vector2) -> Vector2i:
	return pos / cell_length

func to_screen_pos(pos: Vector2i) -> Vector2:
	return pos * cell_length

func within_bounds(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < width and pos.y >= 0 and pos.y < height

func pos_to_idx(pos: Vector2i) -> int:
	return pos.y * width + pos.x

func idx_to_pos(idx: int) -> Vector2i:
	var pos: Vector2i = Vector2i(idx % width, idx / width)
	
	return pos
