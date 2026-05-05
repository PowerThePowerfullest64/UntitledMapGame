extends Node

var no_access_text: String = "none"

@export var day_counter: Label
@export var fps_counter: Label

# cell specific
@export var cell_id: Label
@export var cell_pop: Label
@export var cell_owner_id: Label
@export var cell_terrain_type: Label

# nation specific
@export var nation_title: Label
@export var nation_id: Label
@export var nation_pop: Label
@export var nation_capital: Label
@export var nation_area: Label

func _ready() -> void:
	TimeManager.day_passed.connect(_on_day_passed)

func _process(_delta: float) -> void:
	update_fps_counter()
	
	# cell
	update_cell_id()
	update_cell_pop()
	update_cell_owner()
	update_cell_terrain_type()
	
	# nation
	update_nation_title()
	update_nation_id()
	update_nation_pop()
	update_nation_capital()
	update_nation_area()

func _on_day_passed(day: int) -> void:
	update_day_counter(day)

func update_day_counter(day: int) -> void:
	day_counter.text = "Day = " + str(day)

func update_fps_counter() -> void:
	fps_counter.text = str(Engine.get_frames_per_second()) + " / %.1f" % TimeManager.tps

func update_cell_id() -> void:
	if not PlayerManager.is_cell_selected:
		cell_id.text = "ID = " + no_access_text
		return
	
	cell_id.text = "ID = " + str(PlayerManager.selected_cell_id)

func update_cell_pop() -> void:
	if not PlayerManager.is_cell_selected:
		cell_pop.text = "Pop = " + no_access_text
		return
	
	cell_pop.text = "Pop = %.0f" % MapManager.population[PlayerManager.selected_cell_id]

func update_cell_owner() -> void:
	if not PlayerManager.is_cell_selected:
		cell_owner_id.text = "OwnerID = " + no_access_text
		return
	
	var cell_owner: int = MapManager.owner_id[PlayerManager.selected_cell_id]
	
	if cell_owner == -1:
		cell_owner_id.text = "OwnerID = " + no_access_text
		return
	
	cell_owner_id.text = "OwnerID = " + str(cell_owner)

func update_cell_terrain_type() -> void:
	if not PlayerManager.is_cell_selected:
		cell_terrain_type.text = "TerrainType = " + no_access_text
		return
	
	cell_terrain_type.text = "TerrainType = " + MapManager.terrain_type[PlayerManager.selected_cell_id]

func update_nation_title() -> void:
	if not PlayerManager.is_cell_selected:
		nation_title.text = "Title = " + no_access_text
		return
	
	var id: int = MapManager.owner_id[PlayerManager.selected_cell_id]
	
	if id == -1:
		nation_title.text = "Title = " + no_access_text
		return
	
	nation_title.text = "Title = " + NationManager.nations[id].title

func update_nation_id() -> void:
	if not PlayerManager.is_cell_selected:
		nation_id.text = "ID = " + no_access_text
		return
	
	var id: int = MapManager.owner_id[PlayerManager.selected_cell_id]
	
	if id == -1:
		nation_id.text = "ID = " + no_access_text
		return
	
	nation_id.text = "ID = " + str(id)

func update_nation_pop() -> void:
	if not PlayerManager.is_cell_selected:
		nation_pop.text = "Pop = " + no_access_text
		return
	
	var id: int = MapManager.owner_id[PlayerManager.selected_cell_id]
	
	if id == -1:
		nation_pop.text = "Pop = " + no_access_text
		return
	
	nation_pop.text = "Pop = %0.f" % NationManager.nations[id].population

func update_nation_capital() -> void:
	if not PlayerManager.is_cell_selected:
		nation_capital.text = "Capital = " + no_access_text
		return
	
	var id: int = MapManager.owner_id[PlayerManager.selected_cell_id]
	
	if id == -1:
		nation_capital.text = "Capital = " + no_access_text
		return
	
	nation_capital.text = "Capital = %.0f" % NationManager.nations[id].capital

func update_nation_area() -> void:
	if not PlayerManager.is_cell_selected:
		nation_area.text = "Area = " + no_access_text
		return
	
	var id: int = MapManager.owner_id[PlayerManager.selected_cell_id]
	
	if id == -1:
		nation_area.text = "Area = " + no_access_text
		return
	
	nation_area.text = "Area = " + str(NationManager.nations[id].area)
