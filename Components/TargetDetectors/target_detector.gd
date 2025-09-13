class_name TargetDetectorArea extends Area3D

signal update_target(target: BaseCharacter)

#Defaults: 1 is player (layer) 2 is enemy (mask)
#Swap when used on enemies
@export var init_layer := 0b0001
@export var init_mask := 0b0010

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	collision_layer = init_layer
	collision_mask = init_mask
	
func _on_body_entered(body: Node3D) -> void:
	if body is BaseCharacter:
		print_debug(body)
		update_target.emit(body)
