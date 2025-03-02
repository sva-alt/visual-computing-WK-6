extends CharacterBody3D

@onready var nav = $NavigationAgent3D

var speed = 3.5
var gravity = 9.8

@export
var initial_health : float

var  current_health : float

func _ready() -> void:
	current_health = initial_health	
	$Control/TextureProgressBar.max_value = initial_health

func _process(delta):
	
	if current_health <= 0:
		queue_free()
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 2

	var next_location = nav.get_next_path_position()
	var current_location = global_transform.origin
	var direction = (next_location - current_location).normalized()
	var new_velocity = direction * speed
	velocity = velocity.move_toward(new_velocity, 0.25)

	if velocity.length() > 0.1:
		look_at(current_location + velocity, Vector3.UP)
		# Rotación adicional para corregir la orientación del modelo (ajusta el ángulo según sea necesario)
		rotate_y(deg_to_rad(180)) #Si esta volteado 180 grados, si no, ajusta el valor.

	move_and_slide()

func target_position(target):
	nav.target_position = target
	


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("Bullet"):
		current_health -= 10
		$Control/TextureProgressBar.value = current_health
		
