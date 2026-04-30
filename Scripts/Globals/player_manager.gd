extends Node2D

var cell_selected: bool = false
var selected_cell: Vector2i
var selected_cell_id: int = 0

var hover_color: Color = Color(1, 1, 1, 0.25)
var select_color: Color = Color(1, 1, 1, 0.35)

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		var cell_pos: Vector2i = MapManager.to_map_pos(get_global_mouse_position())
		
		if not MapManager.within_bounds(cell_pos):
			print("Tried to access cell outside bounds of the map.")
			return
		
		var index: int = MapManager.pos_to_idx(cell_pos)
		
		if cell_pos == selected_cell and cell_selected:
			MapManager.selected[index] = 0
			cell_selected = false
			return
		
		if cell_selected:
			MapManager.selected.fill(0)
		
		MapManager.selected[index] = 1
		selected_cell = cell_pos
		selected_cell_id = index
		cell_selected = true
	
	queue_redraw()

func _draw() -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	var cell_pos: Vector2i = MapManager.to_map_pos(mouse_pos)
	
	if MapManager.within_bounds(cell_pos):
		var aligned_mouse_pos: Vector2 = MapManager.to_screen_pos(cell_pos) # aligned to map grid
		var rect: Rect2 = Rect2(aligned_mouse_pos, Vector2(MapManager.cell_length, MapManager.cell_length))
		
		draw_rect(rect, hover_color)
	
	if cell_selected:
		var rect: Rect2 = Rect2(MapManager.to_screen_pos(selected_cell), Vector2(MapManager.cell_length, MapManager.cell_length))
		
		draw_rect(rect, Color.YELLOW, false)
		draw_rect(rect, select_color)
	
