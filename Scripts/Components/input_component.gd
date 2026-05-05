class_name InputComponent extends Node

# down
var move_dir: Vector2 = Vector2.ZERO

# pressed
var zoom_in_pressed: bool = false
var zoom_out_pressed: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func update() -> void:
	# down
	move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# pressed
	zoom_in_pressed = Input.is_action_just_pressed("zoom_in")
	zoom_out_pressed = Input.is_action_just_pressed("zoom_out")
