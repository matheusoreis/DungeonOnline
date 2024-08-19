class_name AlertUI extends PanelContainer


@export var timer: Timer
@export var message: Label
@export_range(0, 10) var timeout: float = 1.0


func _ready() -> void:
	timer.wait_time = timeout
	timer.one_shot = true
	timer.start()


func _on_timer_timeout() -> void:
	queue_free()


func _on_close_button_pressed() -> void:
	queue_free()
