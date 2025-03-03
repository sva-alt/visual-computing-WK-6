extends CharacterBody3D

@onready var nav = $NavigationAgent3D  # Asegúrate de tener un AnimationPlayer con las animaciones
@onready var state_machine =$AnimationTree.get("parameters/playback")
var speed = 3.5
var gravity = 9.8
var is_dying = false
var can_chase = false
var points_for_kill = 100
#health bar



@export var initial_health: float
var current_health: float

func _ready() -> void:
	current_health = initial_health
	$Control/TextureProgressBar.max_value = initial_health
	await get_tree().create_timer(4.0).timeout
	# Solo si el personaje sigue vivo
	if current_health > 0:
		can_chase = true
		state_machine.travel("Running_C")
 

func _physics_process(delta):
	if current_health <= 0 and not is_dying:
		_die()  # Llama a la función de muerte
	
	if is_dying:
		move_and_slide()
		return
	
	# Gravedad
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 2
	
	# Movimiento solo si no está muerto
	if can_chase:
		var next_location = nav.get_next_path_position()
		var current_location = global_transform.origin
		var direction = (next_location - current_location).normalized()
		var new_velocity = direction * speed
		velocity = velocity.move_toward(new_velocity, 0.25)
		
		if velocity.length() > 0.1:
			look_at(current_location + velocity, Vector3.UP)
			rotate_y(deg_to_rad(180))
	
	move_and_slide()

func _die():
	is_dying = true
	velocity = Vector3.ZERO  # Detiene el movimiento
	state_machine.travel("Death_C_Skeletons")
	  # Cambia a animación de muerte
	Global.current_score += points_for_kill
	await get_tree().create_timer(5.0).timeout  # Espera antes de eliminar
	self.queue_free()

func target_position(target):
	nav.target_position = target

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("Bullet"):
		current_health -= 10
		$Control/TextureProgressBar.value = current_health


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		get_tree().call_group("Player","hurt", 10)
	pass # Replace with function body.
