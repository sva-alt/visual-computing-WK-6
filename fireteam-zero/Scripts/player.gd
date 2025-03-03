extends CharacterBody3D

@export var SPEED = 8.0
const JUMP_VELOCITY = 6.0
var health = 100

@onready var progress = $CanvasLayer/ProgressBar


@export var camera: Camera3D


var is_alive: bool = true

var is_hurt = false
var is_dead = false

# Nodo que controla las animaciones del personaje (asegúrate de tenerlo en la escena, por ejemplo "GobotSkin")
@onready var _skin: Node = $GobotSkin

func hurt(hit_poins):
	if !is_hurt:
		is_hurt = true
		$"../HurtTimer".start()
		if hit_poins < health:
			health -= hit_poins
		else:
			health = 0
		$ProgressBar.value = health
		if health == 0:
			die()
	

func die ():
	is_dead = true
	get_tree().reload_current_scene()
	pass
func _physics_process(delta: float) -> void:
	if not is_alive:
		return 

	# Aplicar gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Manejar salto
	var is_starting_jump := Input.is_action_just_pressed("jump") and is_on_floor()
	if is_starting_jump:
		velocity.y += JUMP_VELOCITY

	# Movimiento
	var input_dir := Input.get_vector("move_right", "move_left", "move_down", "move_up")
	var direction := (Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction != Vector3.ZERO and !is_hurt and !is_dead:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

	# Orientación hacia el cursor usando intersección de rayo
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_direction = camera.project_ray_normal(mouse_pos)
	var ray_length = 500.0
	var ray_end = ray_origin + ray_direction * ray_length
	
	var ray_query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	ray_query.collide_with_bodies = true
	var space_state = get_world_3d().direct_space_state
	var ray_result = space_state.intersect_ray(ray_query)
	
	if ray_result and ray_result.has("position"):
		# Evitar que se mire a sí mismo
		if ray_result.collider != self:
			var target_position = ray_result.position
			# Ajustar altura (opcional, dependiendo de tu personaje)
			target_position.y += 1.0 
			look_at(target_position, Vector3.UP)
	
	# --- Animación ---
	if is_starting_jump:
		_skin.jump()  # Método definido en tu nodo de animación
	elif not is_on_floor() and velocity.y < 0:
		_skin.fall()  # Método definido en tu nodo de animación
	elif is_on_floor():
		if velocity.length() > 0.1:
			_skin.run()   # Método definido en tu nodo de animación
		else:
			_skin.idle()  # Método definido en tu nodo de animación

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		if progress.value <=0:
			is_alive = false
		if get_node_or_null("Weapon") != null:
			$Blaster.queue_free()
		if get_node_or_null("MeshInstance3D") != null:
			$MeshInstance3D.queue_free()
			


func _on_hurt_timer_timeout() -> void:
	is_hurt = false
	pass # Replace with function body.
