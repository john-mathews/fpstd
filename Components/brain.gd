class_name Brain extends Node

var area_target: BaseCharacter
var stats: CharacterData

const groups := GroupManager.ENTITY_GROUPS

func setup(model:CharacterData) -> void:
	stats = model

func get_movement(current_velocity: Vector3, position: Vector3, delta:float) -> Vector3:
	if area_target != null && stats != null:
		return _get_velocity(current_velocity, position, area_target.global_position, delta)
	else:
		return find_core_position(current_velocity, position, delta)
	
func _get_velocity(current_velocity: Vector3, position: Vector3, target_position: Vector3, delta:float) -> Vector3:
	var v = (target_position - position).normalized() * stats.movement_speed * delta
	return _no_z(v)
	
func _no_z(vector: Vector3) -> Vector3:
	return Vector3(vector.x, vector.y, 0)
	
func find_core_position(current_velocity: Vector3, position: Vector3, delta:float) -> Vector3:
	var core = get_tree().get_first_node_in_group(groups[GroupManager.CORE])
	return _get_velocity(current_velocity, position, core.global_position, delta)
	
func update_area_target(target: BaseCharacter) -> void:
	area_target = target
