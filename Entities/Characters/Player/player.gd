class_name Player extends BaseCharacter

@export_subgroup("Properties")
@export var player_id = 1

#@export_subgroup("Weapons")
#Commented out a ton of weapon stuff from kenney
#@export var weapons: Array[Weapon] = []
#
#var weapon: Weapon
var weapon_index := 0

var mouse_captured := true

var input_mouse: Vector2

var health: int = 100

var previously_floored := false

var container_offset = Vector3(1.2, -1.1, -2.75)

var tween: Tween

signal health_updated

@onready var camera = $Head/Camera
@onready var raycast = $Head/Camera/RayCast
@onready var muzzle = $Head/Camera/SubViewportContainer/SubViewport/CameraItem/Muzzle
@onready var container = $Head/Camera/SubViewportContainer/SubViewport/CameraItem/Container
#@onready var sound_footsteps = $SoundFootsteps
#@onready var blaster_cooldown = $Cooldown

@export var crosshair: TextureRect

# Functions
func _ready():
	super()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	#weapon = weapons[weapon_index] # Weapon must never be nil
	#initiate_change_weapon(weapon_index)

func _physics_process(delta):
	# Handle functions
	handle_controls(delta)
	#handle_gravity(delta)
	super(delta)
	# Rotation
	camera.rotation.z = lerp_angle(camera.rotation.z, -input_mouse.x * 25 * delta, delta * 5)
	
	camera.rotation.x = lerp_angle(camera.rotation.x, rotation_target.x, delta * 25)
	rotation.y = lerp_angle(rotation.y, rotation_target.y, delta * 25)
	
	container.position = lerp(container.position, container_offset - (basis.inverse() * velocity / 30), delta * 10)
	
	# Movement sound
	
	#sound_footsteps.stream_paused = true
	
	#if is_on_floor():
		#if abs(velocity.x) > 1 or abs(velocity.z) > 1:
			#sound_footsteps.stream_paused = false
	
	# Landing after jump or falling
	
	camera.position.y = lerp(camera.position.y, 0.0, delta * 5)
	
	if is_on_floor() and gravity > 1 and !previously_floored: # Landed
		#Audio.play("sounds/land.ogg")
		camera.position.y = -0.1
	
	previously_floored = is_on_floor()
	
	# Falling/respawning
	
	if position.y < -10:
		get_tree().reload_current_scene()

# Mouse movement

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and mouse_captured:
		input_mouse = event.relative / brain.profile.mouse_sensitivity
		
		rotation_target.y -= event.relative.x /  brain.profile.mouse_sensitivity
		rotation_target.x -= event.relative.y /  brain.profile.mouse_sensitivity
	
	if event.device == $InputController.profile.device_id:
		print(event.device)

func handle_mouse_capture():
	if Input.is_action_just_pressed("mouse_capture"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		mouse_captured = true
	
	if Input.is_action_just_pressed("mouse_capture_exit"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		mouse_captured = false
		
		input_mouse = Vector2.ZERO
		
func handle_jumps():
	if jump_count < max_jumps:
		jump_count += 1
		
func handle_controls(_delta):
	handle_mouse_capture()
	
	# Shooting
	action_shoot()
	
	if Input.is_action_just_pressed("jump"):
		var info = brain.jump(jump_strength, gravity, model.max_jumps, jump_count)
		gravity = info.gravity
		jump_count = info.jump_count

			
	# Weapon switching
	#action_weapon_toggle()

# Shooting

func action_shoot():
	if Input.is_action_pressed("shoot"):
		#if !blaster_cooldown.is_stopped(): return # Cooldown for shooting
		#Audio.play(weapon.sound_shoot)
		container.position.z += 0.25 # Knockback of weapon visual
		camera.rotation.x += 0.025 # Knockback of camera
		#movement_velocity += Vector3(0, 0, weapon.knockback) # Knockback
		
		# Set muzzle flash position, play animation
		
		#muzzle.play("default")
		
		muzzle.rotation_degrees.z = randf_range(-45, 45)
		muzzle.scale = Vector3.ONE * randf_range(0.40, 0.75)
		#muzzle.position = container.position - weapon.muzzle_position
		#
		#blaster_cooldown.start(weapon.cooldown)
		
		# Shoot the weapon, amount based on shot count
		#
		#for n in weapon.shot_count:
			#raycast.target_position.x = randf_range(-weapon.spread, weapon.spread)
			#raycast.target_position.y = randf_range(-weapon.spread, weapon.spread)
			#
			#raycast.force_raycast_update()
			#
			#if !raycast.is_colliding(): continue # Don't create impact when raycast didn't hit
			#
			#var collider = raycast.get_collider()
			#
			## Hitting an enemy
			#
			#if collider.has_method("damage"):
				#collider.damage(weapon.damage)
			#
			## Creating an impact animation
			#
			#var impact = preload("res://objects/impact.tscn")
			#var impact_instance = impact.instantiate()
			#
			#impact_instance.play("shot")
			#
			#get_tree().root.add_child(impact_instance)
			#
			#impact_instance.position = raycast.get_collision_point() + (raycast.get_collision_normal() / 10)
			#impact_instance.look_at(camera.global_transform.origin, Vector3.UP, true)

# Toggle between available weapons (listed in 'weapons')

#func action_weapon_toggle():
	#if Input.is_action_just_pressed("weapon_toggle"):
		#weapon_index = wrap(weapon_index + 1, 0, weapons.size())
		#initiate_change_weapon(weapon_index)
		#
		#Audio.play("sounds/weapon_change.ogg")

# Initiates the weapon changing animation (tween)

#func initiate_change_weapon(index):
	#weapon_index = index
	#
	#tween = get_tree().create_tween()
	#tween.set_ease(Tween.EASE_OUT_IN)
	#tween.tween_property(container, "position", container_offset - Vector3(0, 1, 0), 0.1)
	#tween.tween_callback(change_weapon) # Changes the model
#
## Switches the weapon model (off-screen)
#
#func change_weapon():
	#weapon = weapons[weapon_index]
#
	## Step 1. Remove previous weapon model(s) from container
	#
	#for n in container.get_children():
		#container.remove_child(n)
	#
	## Step 2. Place new weapon model in container
	#
	#var weapon_model = weapon.model.instantiate()
	#container.add_child(weapon_model)
	#
	#weapon_model.position = weapon.position
	#weapon_model.rotation_degrees = weapon.rotation
	#
	## Step 3. Set model to only render on layer 2 (the weapon camera)
	#
	#for child in weapon_model.find_children("*", "MeshInstance3D"):
		#child.layers = 2
		#
	## Set weapon data
	#
	#raycast.target_position = Vector3(0, 0, -1) * weapon.max_distance
	#crosshair.texture = weapon.crosshair
