class_name Cell extends Object

var id: int
var population: float = 100.0

func _init(_id: int) -> void:
	id = _id

func update() -> void:
	population += population * 0.005 # grow pop
