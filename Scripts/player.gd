extends Node2D

@export var input_component: InputComponent
@export var movement_component: MovementComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	input_component.update()
	movement_component.update(delta)
