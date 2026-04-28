extends Label

func _ready() -> void:
	TimeManager.day_passed.connect(_on_day_passed)

func _on_day_passed(day: int) -> void:
	text = "Day: " + str(day)
