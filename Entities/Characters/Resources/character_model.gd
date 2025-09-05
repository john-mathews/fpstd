class_name CharacterData extends Resource

enum CharacterTypes {
	CORE,
	TOWER,
	ENEMY,
	PLAYER
}

enum MoveTypes {
	STATIC,
	GROUND,
	AIR
}

@export var max_health := 100
#@export var weapons: Array[Weapon]
@export var character_type: CharacterTypes
@export var movement_speed := 5
@export var jump_strength := 8
@export var max_jumps := 1
@export var movement_type: MoveTypes
