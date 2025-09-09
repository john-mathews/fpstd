class_name PlayerInputProfile extends Resource
#This is setting up for Local multiplayer 

@export_enum('p1', 'p2', 'p3', 'p4') var player_id: String = 'p1'

# -1 = kbm
# other device ids are index of Input.get_connected_joypads()
var device_id := -1

var player_actions: Array[String] = InputMap.get_actions().filter(_match_pid)
		
var generic_actions: Array[String] = player_actions.map(_get_action_name)
		
var action_map: Dictionary [String, String] = _generate_action_map()

func _match_pid(action: String) -> bool:
	return action.ends_with(player_id)

func _generate_action_map() -> Dictionary [String, String]:
	var action_dict: Dictionary [String, String] = {}
	for i in range(player_actions.size()):
		action_dict.get_or_add(generic_actions[i], player_actions[i])
	print(action_dict)
	return action_dict

func _get_action_name(name: String) -> String:
	var idx = name.find("_%s" % player_id)
	print(idx)
	return name.substr(0, idx)
	
