extends Node

@export var no_access_text: String = "None"

@export var day_counter: Label
@export var fps_counter: Label

# cell specific
@export var cell_info_panel: Panel
@export var cell_id: Label
@export var cell_pop: Label
@export var cell_owner_id: Label
@export var cell_terrain_type: Label

# nation specific
@export var nation_info_panel: Panel
@export var nation_title: Label
@export var nation_id: Label
@export var nation_pop: Label
@export var nation_capital: Label
@export var nation_area: Label

func _ready() -> void:
	TimeManager.day_passed.connect(_on_day_passed)

func _process(_delta: float) -> void:
	update_fps()

func _on_day_passed(day: int) -> void:
	update_day(day)

func update_day(day: int) -> void:
	day_counter.text = "Day = " + str(day)

func update_fps() -> void:
	fps_counter.text = str(Engine.get_frames_per_second()) + " / %.1f" % TimeManager.tps

func update_cell_ui(id: int) -> void:
	if id == -1:
		cell_info_panel.hide()
		return
	
	cell_info_panel.show()
	
	# cell
	update_cell_id(id)
	update_cell_pop(id)
	update_cell_owner(id)
	update_cell_terrain_type(id)

func update_cell_id(id: int) -> void:
	cell_id.text = "ID = " + str(id)

func update_cell_pop(id: int) -> void:
	cell_pop.text = "Pop = %.0f" % MapManager.population[id]

func update_cell_owner(id: int) -> void:
	var cell_owner: int = MapManager.owner_id[id]
	
	if cell_owner == -1:
		cell_owner_id.text = "OwnerID = " + no_access_text
		return
	
	cell_owner_id.text = "OwnerID = " + str(cell_owner)

func update_cell_terrain_type(id: int) -> void:
	cell_terrain_type.text = "TerrainType = " + MapManager.terrain_name[MapManager.terrain_type[id]]

func update_nation_ui(id: int) -> void:
	if not MapManager.selected[id] == 1:
		nation_info_panel.hide()
		return
	
	var owner_id: int = MapManager.owner_id[id]
	
	if owner_id == -1:
		nation_info_panel.hide()
		return
	
	nation_info_panel.show()
	
	# nation
	update_nation_title(owner_id)
	update_nation_id(owner_id)
	update_nation_pop(owner_id)
	update_nation_capital(owner_id)
	update_nation_area(owner_id)

func update_nation_title(id: int) -> void:
	nation_title.text = "Title = " + NationManager.nations[id].title

func update_nation_id(id: int) -> void:	
	nation_id.text = "ID = " + str(id)

func update_nation_pop(id: int) -> void:
	nation_pop.text = "Pop = %0.f" % NationManager.nations[id].population

func update_nation_capital(id: int) -> void:
	nation_capital.text = "Capital = %.0f" % NationManager.nations[id].capital

func update_nation_area(id: int) -> void:
	nation_area.text = "Area = " + str(NationManager.nations[id].area)
