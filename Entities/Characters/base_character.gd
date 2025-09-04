class_name BaseCharacter extends CharacterBody3D

@export_subgroup("Health")
@export var max_health := 100
var current_health: int:
	get():
		if health_component != null:
			return health_component.entity_health
		else:
			print_debug('no health component')
			return 1

@export_subgroup("Movement")
@export var movement_speed := 5
@export var jump_strength := 8
@export var max_jumps := 1

@export_subgroup("Nodes")
#This is type node so that it can be a Sprite3d for towers, enemies, core
#But can be a ui element for player.
#update_health_bar func required
@export var health_bar : Node

var health_component : HealthComponent

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
