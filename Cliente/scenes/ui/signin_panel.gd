extends PanelContainer


@export var email_edit : LineEdit
@export var password_edit : LineEdit
@export var signup_panel: PanelContainer

var _signin: SignInMessage


func _ready() -> void:
	_signin = SignInMessage.new()


func _on_access_pressed() -> void:
	_signin.email = email_edit.text
	_signin.password = password_edit.text

	_signin.send()


func _on_create_pressed() -> void:
	signup_panel.show()
	self.hide()
