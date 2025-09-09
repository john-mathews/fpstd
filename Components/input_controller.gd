class_name InputController extends Brain

@export var profile: PlayerInputProfile
var left: String = profile.action_map.get('move_left')
var right: String = profile.action_map.get('move_right')
var forward: String = profile.action_map.get('move_forward')
var backward: String = profile.action_map.get('move_back')

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

func get_movement(current_velocity: Vector3, position: Vector3, delta:float) -> Vector3:
	var v = (Input.get_vector(left, right, forward, backward)).normalized() * stats.movement_speed * delta
	return _no_z(v+current_velocity)
