class_name SelectorComponent extends Node2D

var is_cell_selected: bool = false
var selected_cell_pos: Vector2i
var selected_cell_id: int = -1

@export var hover_color: Color = Color(1, 1, 1, 0.25)
@export var select_color: Color = Color(1, 1, 1, 0.35)

@export var input_component: InputComponent

signal selected_cell(cell_id: int)

func _ready() -> void:
	var ui_manager: Control = %UIManager
	
	selected_cell.connect(ui_manager.update_cell_ui)
	selected_cell.connect(ui_manager.update_nation_ui)
	TimeManager.day_passed.connect(update_ui)
func _process(delta: float) -> void:
	update()

func update_ui(_day: int) -> void:
	selected_cell.emit(selected_cell_id)

func update() -> void:
	update_cell_moving()
	update_cell_selecting()
	update_cell_transfer()
	
	queue_redraw()

func update_cell_selecting() -> void:
	if input_component.select_pressed:
		var cell_pos: Vector2i = MapManager.to_map_pos(get_global_mouse_position())
		
		if not MapManager.within_bounds(cell_pos):
			print("Tried accessing cell out of bounds; please don't do that")
			return
		
		var id: int = MapManager.pos_to_idx(cell_pos)
		
		if cell_pos == selected_cell_pos and is_cell_selected:
			MapManager.selected[id] = 0
			is_cell_selected = false
			selected_cell_id = -1
			selected_cell.emit(selected_cell_id)
			return
		
		if is_cell_selected:
			var previous_selected_id: int = MapManager.pos_to_idx(selected_cell_pos)
			MapManager.selected[previous_selected_id] = 0
		
		MapManager.selected[id] = 1
		selected_cell_pos = cell_pos
		selected_cell_id = id
		is_cell_selected = true
		selected_cell.emit(selected_cell_id)

func update_cell_moving() -> void:
	var cell_move: Vector2i = Vector2i.ZERO
	if input_component.cell_up_pressed: cell_move.y -= 1
	if input_component.cell_left_pressed: cell_move.x -= 1
	if input_component.cell_down_pressed: cell_move.y += 1
	if input_component.cell_right_pressed: cell_move.x += 1
	
	var new_cell_pos: Vector2i = selected_cell_pos + cell_move
	
	if not is_cell_selected or cell_move == Vector2i.ZERO or not MapManager.within_bounds(new_cell_pos):
		return
	
	var previous_id: int = MapManager.pos_to_idx(selected_cell_pos)
	MapManager.selected[previous_id] = 0
	
	selected_cell_pos = new_cell_pos
	selected_cell_id = MapManager.pos_to_idx(new_cell_pos)
	MapManager.selected[selected_cell_id] = 1
	selected_cell.emit(selected_cell_id)

func update_cell_transfer() -> void:
	if input_component.transfer_cell_pressed:
		if not is_cell_selected:
			return
		
		var cell_owner_id: int = MapManager.owner_id[selected_cell_id]
		var new_cell_owner_id: int = cell_owner_id + 1
		
		if new_cell_owner_id == 3:
			new_cell_owner_id -= 4
			NationManager.nations[cell_owner_id].remove_cell(selected_cell_id)
			return
		
		NationManager.nations[new_cell_owner_id].add_cell(selected_cell_id)
		
		selected_cell.emit(selected_cell_id)

func _draw() -> void:
	var mouse_pos_global: Vector2 = get_global_mouse_position()
	var cell_pos: Vector2i = MapManager.to_map_pos(mouse_pos_global)
	
	if MapManager.within_bounds(cell_pos):
		var cell_global: Vector2 = MapManager.to_screen_pos(cell_pos)
		var cell_local: Vector2 = to_local(cell_global)
		
		var rect: Rect2 = Rect2(cell_local, Vector2(MapManager.cell_length, MapManager.cell_length))
		draw_rect(rect, hover_color)
	
	if is_cell_selected:
		var cell_global: Vector2 = MapManager.to_screen_pos(selected_cell_pos)
		var cell_local: Vector2 = to_local(cell_global)
		
		var rect: Rect2 = Rect2(cell_local, Vector2(MapManager.cell_length, MapManager.cell_length))
		
		draw_rect(rect, Color.YELLOW, false, 2.5)
		draw_rect(rect, select_color)
