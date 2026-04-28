extends Camera2D

@export var speed: float = 750.0

func _process(delta: float) -> void:
	update_movement(delta)

func update_movement(delta: float) -> void:
	var move_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	position += move_dir * speed * delta
