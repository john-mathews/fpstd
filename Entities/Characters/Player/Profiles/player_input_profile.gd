class_name PlayerInputProfile extends Resource
#This is setting up for Local multiplayer 

@export_enum('p1', 'p2', 'p3', 'p4') var player_id: String = 'p1'

# -1 = kbm
# other device ids are index of Input.get_connected_joypads()
var device_id := -1
@export var mouse_sensitivity = 700
@export var gamepad_sensitivity := 0.075

var player_actions: Array[StringName] = InputMap.get_actions().filter(_match_pid)
		
var generic_actions: Array[String] = _generate_generic_actions(player_actions)
		
var action_map: Dictionary [String, StringName] = _generate_action_map()

func _match_pid(action: StringName) -> bool:
	return action.ends_with(player_id)

func _generate_action_map() -> Dictionary [String, StringName]:
	var action_dict: Dictionary [String, StringName] = {}
	for i in range(player_actions.size()):
		action_dict.get_or_add(generic_actions[i], player_actions[i])
	print(action_dict)
	return action_dict
	
func _generate_generic_actions(pa: Array[StringName]) -> Array[String]:
	var ga: Array[String]
	for action in pa:
		ga.push_back(_get_action_name(action))
	return ga

func _get_action_name(name: StringName) -> String:
	var idx = name.find("_%s" % player_id)
	print(idx)
	return name.substr(0, idx)
	
