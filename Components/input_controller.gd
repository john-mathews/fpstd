class_name InputController extends Brain

@export var profile: PlayerInputProfile

func get_action_strength(action_name: String) -> float:
	var mapped = profile.action_map.get(action_name, action_name)
	return Input.get_action_strength(mapped)

func is_action_pressed(action_name: String) -> bool:
	var mapped = profile.action_map.get(action_name, action_name)
	return Input.is_action_pressed(mapped)
