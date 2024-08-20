class_name AuthenticateUI extends PanelContainer


@export_category('TopBar')
@export var title: String = 'Base Window'
@export var title_label: Label
@export var close_button: Button

@export_category('Content')
@export var email_edit: LineEdit
@export var password_edit: LineEdit
@export var send_button: Button

var _signin: SignInMessage


func _ready() -> void:
	title_label.text = title
	close_button.show()
	_signin = SignInMessage.new()


func _on_send_button_pressed() -> void:
	_signin.email = email_edit.text
	_signin.password = password_edit.text
	_signin.send()


func _on_close_button_pressed() -> void:
	get_tree().quit()
