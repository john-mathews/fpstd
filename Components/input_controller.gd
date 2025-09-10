class_name InputController extends Brain

@export var profile: PlayerInputProfile
var left: String
var right: String
var forward: String
var backward: String

func _ready() -> void:
	_setup_actions()

func get_action_strength(action_name: String, device_id: int) -> float:
	if device_id != profile.device_id:
		return 0.0
	var mapped = profile.action_map.get(action_name, action_name)
	return Input.get_action_strength(mapped)

func is_action_pressed(action_name: String, device_id: int) -> bool:
	if device_id != profile.device_id:
		return false
	var mapped = profile.action_map.get(action_name, action_name)
	return Input.is_action_pressed(mapped)

func get_movement(_current_velocity: Vector3, _position: Vector3, _delta:float) -> Vector3:
	var input_v = Input.get_vector(left, right, forward, backward)
	var v = input_v.normalized() * stats.movement_speed
	var v3 = Vector3(v.x, 0.0, v.y)
	return _no_y(v3)

func get_rotation(rotation_target: Vector3) -> Vector3:
	var rotation_input := Input.get_vector("camera_right", "camera_left", "camera_down", "camera_up")
	rotation_target -= Vector3(-rotation_input.y, -rotation_input.x, 0).limit_length(1.0) * profile.gamepad_sensitivity
	rotation_target.x = clamp(rotation_target.x, deg_to_rad(-90), deg_to_rad(90))
	return rotation_target

func _setup_actions() -> void:
	left = profile.action_map.get('move_left')
	right = profile.action_map.get('move_right')
	forward = profile.action_map.get('move_forward')
	backward = profile.action_map.get('move_back')
