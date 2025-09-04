class_name HealthComponent extends RefCounted

signal update_health
signal kill

var entity_health := 1:
	get():
		return entity_health
	set(value):
		entity_health = value
		update_health.emit()
		if entity_health <= 0:
			print_debug('kill parent entity')
			kill.emit()

var max_health := 1

func _init(starting_health: int) -> void:
	max_health = starting_health
	entity_health = starting_health
	
func _update_health(health_change: int) -> void:
	entity_health += health_change

func heal(heal_amount: int) -> void:
	_update_health(heal_amount)
	
func damage(damage_amount: int) -> void:
	_update_health(-damage_amount)

func full_heal() -> void:
	entity_health = max_health
	
