class_name AlertPanel


extends PanelContainer


enum AlertType {
	info,
	warning,
	error,
}


@export var _title: Label
@export var _message : Label

var _type: AlertType = AlertType.info


func set_message(new_message: String) -> void:
	_message.text = new_message


func set_type(alert_type) -> void:
	_type = alert_type
	match _type as AlertType:
		AlertType.info:
			_title.text = 'Informação!'
		AlertType.warning:
			_title.text = 'Atenção!'
		AlertType.error:
			_title.text = 'Erro!'


func _on_button_pressed() -> void:
	match _type as AlertType:
		AlertType.info:
			print('info')
			self.queue_free()
		AlertType.warning:
			print('Error')
			self.queue_free()
		AlertType.error:
			print('Error')
			self.queue_free()
