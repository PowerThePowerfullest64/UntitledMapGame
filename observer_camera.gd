extends Camera2D

@export var speed: float = 750.0
@export var zoom_sensitivity: float = 1.0
@export var zoom_rate: float = 10.0

@export var min_zoom: float = 0.1
@export var max_zoom: float = 10.0

var target_zoom: Vector2

func _ready() -> void:
	target_zoom = zoom

func _process(delta: float) -> void:
	update_movement(delta)
	update_zoom()
	zoom = zoom.lerp(target_zoom, zoom_rate * delta)

func update_movement(delta: float) -> void:
	var move_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	position += move_dir * speed / zoom.x * delta

func update_zoom() -> void:
	if Input.is_action_just_pressed("zoom_in"):
		target_zoom *= 1.0 + (0.1 * zoom_sensitivity)
	elif Input.is_action_just_pressed("zoom_out"):
		target_zoom /= 1.0 + (0.1 * zoom_sensitivity)
	
	# cap zoom
	target_zoom = Vector2(max(min(target_zoom.x, max_zoom), min_zoom), max(min(target_zoom.y, max_zoom), min_zoom))
