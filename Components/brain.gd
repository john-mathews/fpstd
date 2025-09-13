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
		
func get_rotation(_rotation_target: Vector3) -> Vector3:
	return Vector3.ZERO
	
func _get_velocity(_current_velocity: Vector3, position: Vector3, target_position: Vector3, _delta:float) -> Vector3:
	var v = (target_position - position).normalized() * stats.movement_speed
	return _no_y(v)
	
func _no_y(vector: Vector3) -> Vector3:
	return Vector3(vector.x, 0, vector.z)
	
func find_core_position(current_velocity: Vector3, position: Vector3, delta:float) -> Vector3:
	var core = get_tree().get_first_node_in_group(groups[GroupManager.CORE])
	return _get_velocity(current_velocity, position, core.global_position, delta)
	
func update_area_target(target: BaseCharacter) -> void:
	area_target = target
	
func jump(jump_strength: float, gravity: float, max_jumps: int, jump_count: int) -> JumpInfo:
	var info = JumpInfo.new()
	if jump_count < max_jumps:
		gravity = - jump_strength
		jump_count += 1
		#Audio.play("sounds/jump_a.ogg, sounds/jump_b.ogg, sounds/jump_c.ogg")
	info.jump_count = jump_count
	info.gravity = gravity
	return info

class JumpInfo:
	var gravity
	var jump_count
