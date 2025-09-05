class_name BaseCharacter extends CharacterBody3D

@export_subgroup("Model")
@export var model: CharacterData

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

@export_subgroup("Nodes")
#This is type node so that it can be a Sprite3d for towers, enemies, core
#But can be a ui element for player.
#update_health_bar func required
@export var health_bar: Node

var health_component: HealthComponent

func _init() -> void:
	health_component = HealthComponent.new(max_health)
	health_component.connect('update_health', _update_health)
	health_component.connect('kill', _die)
	
func _ready() -> void:
	if health_bar != null && health_bar.has_method('update_health_bar'):
		health_bar.update_health_bar(max_health, max_health)

func _update_health() -> void:
	if health_bar != null && health_bar.has_method('update_health_bar'):
		health_bar.update_health_bar(current_health, max_health)

func _die() -> void:
	print('oh no %s died' % name)
	queue_free()
	
func take_damage(damage_amount: int) -> void:
	health_component.damage(damage_amount)

func heal(heal_amount: int) -> void:
	health_component.heal(heal_amount)
