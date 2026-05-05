extends Node

var nations: Array[Nation] = [Nation.new("Empire of Eldia", 0), Nation.new("Nation1", 1), Nation.new("Nation2", 2)]

var tilemaplayer: TileMapLayer

func _ready() -> void:
	tilemaplayer = get_node("/root/main/PoliticalLayer")
	
	TimeManager.day_passed.connect(tick)
	
	for i in range(192*32): nations[0].add_cell(i)

func update_nations() -> void:
	for nation in nations:
		nation.update()

func tick(_day: int) -> void:
	update_nations()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("change_cell_owner"):
		if not PlayerManager.is_cell_selected:
			return
		
		var cell_owner_id: int = MapManager.owner_id[PlayerManager.selected_cell_id]
		var new_cell_owner_id: int = cell_owner_id + 1
		
		if new_cell_owner_id == 3:
			new_cell_owner_id -= 4
			NationManager.nations[cell_owner_id].remove_cell(PlayerManager.selected_cell_id)
			return
		
		NationManager.nations[new_cell_owner_id].add_cell(PlayerManager.selected_cell_id)
