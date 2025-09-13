class_name BaseCharacter extends CharacterBody3D

@export var model: CharacterData
@export_subgroup("Nodes")
#This is type node so that it can be a Sprite3d for towers, enemies, core
#But can be a ui element for player.
#update_health_bar func required
@export var health_bar: Node
@export var target_detector_area: TargetDetectorArea
@export var brain: Brain

var health_component: HealthComponent

var movement_velocity: Vector3
var rotation_target: Vector3
var gravity := 0.0
var jump_count := 0

var max_health: int:
	get():
		if model != null:
			return model.max_health
		else:
			print_debug('no Character Data Model')
			return 1

var current_health: int:
	get():
		if health_component != null:
			return health_component.entity_health
		else:
			print_debug('no health component')
			return 1

var movement_speed: int:
	get():
		if model != null:
			return model.movement_speed
		else:
			print_debug('no Character Data Model')
			return 1

var jump_strength: int:
	get():
		if model != null:
			return model.jump_strength
		else:
			print_debug('no Character Data Model')
			return 1

var max_jumps: int:
	get():
		if model != null:
			return model.max_jumps
		else:
			print_debug('no Character Data Model')
			return 1

func _ready() -> void:
	health_component = HealthComponent.new(max_health)
	health_component.connect('update_health', _update_health)
	health_component.connect('kill', _die)
	
	if health_bar != null && health_bar.has_method('update_health_bar'):
		health_bar.update_health_bar(max_health, max_health)
	
	if target_detector_area != null:
		target_detector_area.update_target.connect(_update_target_from_area)
		
	if brain != null && brain.has_method('setup'):
		brain.setup(model)
		
func _physics_process(delta: float) -> void:
	if brain != null:
		_brain_update(delta)
	var applied_velocity: Vector3
	
	movement_velocity = transform.basis * movement_velocity # Move forward
	
	applied_velocity = velocity.lerp(movement_velocity, delta * model.acceleration)
	if model.movement_type == CharacterData.MoveTypes.GROUND:
		_handle_gravity(delta)
		applied_velocity.y = - gravity
	
	velocity = applied_velocity
	move_and_slide()

func _brain_update(delta: float) -> void:
	if brain != null:
		if brain.has_method('get_movement'):
			movement_velocity = brain.get_movement(velocity, global_position, delta)
		if brain.has_method('get_rotation'):
			rotation_target = brain.get_rotation(rotation_target)

func _update_health() -> void:
	if health_bar != null && health_bar.has_method('update_health_bar'):
		health_bar.update_health_bar(current_health, max_health)

func _die() -> void:
	print('oh no %s died' % name)
	queue_free()

func _update_target_from_area(target: BaseCharacter) -> void:
	if target_detector_area != null && brain != null:
		brain.update_area_target(target)
	elif brain == null:
		print_debug('null brain on %s' % name)

func take_damage(damage_amount: int) -> void:
	health_component.damage(damage_amount)
	#health -= amount
	#health_updated.emit(health) # Update health on HUD
	
	#if health < 0:
		#get_tree().reload_current_scene() # Reset when out of health
		
func heal(heal_amount: int) -> void:
	health_component.heal(heal_amount)

func _handle_gravity(delta):
	gravity += model.grav_acceleration * delta
	
	if gravity > 0 and is_on_floor():
		jump_count = 0
		gravity = 0
