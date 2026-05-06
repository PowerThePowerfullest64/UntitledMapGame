class_name ZoomComponent extends Node

@export var sensitivity: float = 5.0
@export var min_zoom: float = 0.1
@export var max_zoom: float = 10.0
## How quickly it interpolates to target zoom
@export var zoom_rate: float = 5.0

@export var target: Camera2D
@export var input_component: InputComponent

var target_zoom: Vector2

func _ready() -> void:
	target_zoom = target.zoom

func update(delta: float) -> void:
	if input_component.zoom_in_pressed:
		target_zoom *= 1.0 + (0.05 * sensitivity)
	if input_component.zoom_out_pressed:
		target_zoom /= 1.0 + (0.05 * sensitivity)
	
	target_zoom.x = clampf(target_zoom.x, min_zoom, max_zoom)
	target_zoom.y = clampf(target_zoom.y, min_zoom, max_zoom)
	target.zoom = target.zoom.lerp(target_zoom, zoom_rate * delta)
	
