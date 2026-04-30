extends Node

var no_access_text: String = "none"

@export var day_counter: Label
@export var fps_counter: Label

# cell specific
@export var cell_id: Label
@export var pop_counter: Label
@export var owner_id: Label

func _ready() -> void:
	TimeManager.day_passed.connect(_on_day_passed)

func _process(_delta: float) -> void:
	update_fps_counter()
	update_cell_id()
	update_pop_counter()
	update_cell_owner()

func _on_day_passed(day: int) -> void:
	update_day_counter(day)

func update_day_counter(day: int) -> void:
	day_counter.text = "Day = " + str(day)

func update_fps_counter() -> void:
	fps_counter.text = str(Engine.get_frames_per_second()) + " / " + str(TimeManager.tps)

func update_cell_id() -> void:
	if not PlayerManager.cell_selected:
		cell_id.text = "CellID = " + no_access_text
		return
	
	cell_id.text = "CellID = " + str(PlayerManager.selected_cell_id)

func update_pop_counter() -> void:
	if not PlayerManager.cell_selected:
		pop_counter.text = "Pop = " + no_access_text
		return
	
	pop_counter.text = "Pop = %.0f" % MapManager.population[PlayerManager.selected_cell_id]

func update_cell_owner() -> void:
	if not PlayerManager.cell_selected:
		owner_id.text = "OwnerID = " + no_access_text
		return
	
	var cell_owner: int = MapManager.owner_id[PlayerManager.selected_cell_id]
	
	if cell_owner == -1:
		owner_id.text = "OwnerID = " + no_access_text
		return
	
	owner_id.text = "OwnerID = " + str(cell_owner)
