@tool
extends StaticBody3D

@export var dimensions:= Vector3.ONE
@export_tool_button('Refresh Wall Size') var refresh_button = set_wall

@export var collision: CollisionShape3D
@export var mesh: MeshInstance3D

@onready var collsion_node:= $CollisionShape3D
@onready var mesh_node:= $MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if collision == null: collision =  collsion_node
	if mesh == null: mesh =  mesh_node
	set_wall()


func set_wall() -> void:
	collision.shape.size = dimensions
	mesh.mesh.size = dimensions
	
