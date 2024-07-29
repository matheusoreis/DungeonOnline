extends CharacterBody2D
class_name BaseCharacter

enum AttackType {
	MELEE,
	PUCH,
	CAST,
}

@export_category('Variables')
@export var _speed: float = 100
@export var _attack_type: AttackType

@export_category('Objects')
@export var _animation_player: AnimationPlayer
@export var _player_name: Label
@export var _camera: Camera2D


var player_id: int
var player_name: String
var is_local_player: bool = false

var _last_direction: Vector2 = Vector2.DOWN
var _is_attacking: bool = false

var _last_update_time: float = 0.0
var _update_interval: float = 0.1
var _tween_duration: float = 0.2

func _ready() -> void:
	print('PlayerID: ', player_id)
	print('PlayerName: ',player_name)
	print('PlayerLocal: ',is_local_player)
	_player_name.text = player_name
	_camera.enabled = is_local_player
	play_animation('idle', _last_direction)


func _physics_process(delta: float) -> void:
	if is_local_player:
		handle_input()
		#if (Time.get_ticks_msec() - _last_update_time) / 1000.0 >= _update_interval:
			#send_position_to_server()
			#_last_update_time = Time.get_ticks_msec()


func handle_input() -> void:
	if _is_attacking:
		return

	var direction = get_movement_direction()
	
	if direction != Vector2.ZERO:
		_last_direction = direction
		velocity = direction * _speed
		move_and_slide()
		play_animation('walking', _last_direction)
		#update_base_animation.rpc_id(1, 'walking', _last_direction)
	else:
		velocity = Vector2.ZERO
		move_and_slide()
		play_animation('idle', _last_direction)
		#update_base_animation.rpc_id(1,  'idle', _last_direction)

	if Input.is_action_just_pressed('attack'):
		perform_attack()

func get_movement_direction() -> Vector2:
	var direction = Vector2.ZERO

	if Input.is_action_pressed('walking_left'):
		direction.x -= 1
	elif Input.is_action_pressed('walking_right'):
		direction.x += 1
	elif Input.is_action_pressed('walking_up'):
		direction.y -= 1
	elif Input.is_action_pressed('walking_down'):
		direction.y += 1

	return direction

func play_animation(action: String, direction: Vector2) -> void:
	if _is_attacking:
		return

	var direction_label = get_direction_label(direction)
	
	if direction_label != '':
		_animation_player.play('%s_%s' % [action, direction_label])

func get_direction_label(direction: Vector2) -> String:
	if direction == Vector2.LEFT:
		return 'left'
	elif direction == Vector2.UP:
		return 'up'
	elif direction == Vector2.RIGHT:
		return 'right'
	elif direction == Vector2.DOWN:
		return 'down'
	return ''

func perform_attack() -> void:
	_is_attacking = true
	set_physics_process(false)
	var attack_action = get_attack_animation(_attack_type)
	#update_base_animation.rpc_id(1, attack_action, _last_direction)
	_animation_player.play('%s_%s' % [attack_action, get_direction_label(_last_direction)])


func get_attack_animation(attack_type: AttackType) -> String:
	match attack_type:
		AttackType.MELEE:
			return 'attack_sword'
		AttackType.PUCH:
			return 'attack_punch'
		AttackType.CAST:
			return 'attack_cast'
	return 'attack_sword'

func _animation_finished(anim_name: String) -> void:
	if anim_name.begins_with('attack_'):
		_is_attacking = false
		set_physics_process(true)
