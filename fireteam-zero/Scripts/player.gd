extends CharacterBody3D

@export
var SPEED = 5.0
const JUMP_VELOCITY = 4.5
@export
var camera : Camera3D




var is_alive : bool = true
func _physics_process(delta: float) -> void:
	
	if !is_alive:
		return 
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector( "right", "left", "back", "forward")
	var direction := (Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin =  camera.project_ray_origin(mouse_pos)
	var ray_direction = camera.project_ray_normal(mouse_pos) *  500
	var ray_query = PhysicsRayQueryParameters3D.create(ray_origin,ray_direction)
	
	ray_query.collide_with_bodies = true
	var space_states = get_world_3d().direct_space_state
	var ray_result = space_states.intersect_ray(ray_query)
	
	if !ray_result.is_empty():
		if ray_result.collider != self:
			var target_position = ray_result.position
			target_position.y += 1.0 
			look_at(target_position)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		is_alive = false 
		$Weapon.queue_free()
		$MeshInstance3D.queue_free()
		
		
	pass # Replace with function body.
