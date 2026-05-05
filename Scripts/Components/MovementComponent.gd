class_name MovementComponent extends Node

@export var speed: float = 250.0

@export var target: Node2D
@export var input_component: InputComponent
@export var camera: Camera2D

func update(delta: float) -> void:
	if is_instance_valid(camera):
		target.position += input_component.move_dir * speed / camera.zoom.x * delta
	else:
		target.position += input_component.move_dir * speed * delta
