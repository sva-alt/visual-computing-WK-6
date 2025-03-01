extends Node3D

@export var bullet_prefab: PackedScene
@export var shoot_position: Node3D = null  # Punto de disparo
@export var shoot_rate: float = 0.25

var shoot_timer: float = 0.0

func _ready():
	# Si shoot_position no se asignó, intenta obtener un nodo hijo llamado "ShootPosition"
	if shoot_position == null:
		shoot_position = get_node_or_null("ShootPosition")
		if shoot_position == null:
			push_error("shoot_position no está asignado. Se usará el nodo actual.")
			shoot_position = self

func _process(delta):
	shoot_timer += delta

	if Input.is_action_pressed("shoot") and shoot_timer >= shoot_rate:
		shoot_timer = 0
		var bullet = bullet_prefab.instantiate()
		
		# Agregar la bala a la raíz de la escena para que no herede el movimiento del jugador
		get_tree().get_current_scene().add_child(bullet)
		
		# Establecer la posición global de la bala según shoot_position
		bullet.global_position = shoot_position.global_position
		
		# Establecer la dirección de la bala:
		# Se toma la dirección "hacia adelante" del arma (-global_transform.basis.z)
		# y se rota 90° alrededor del eje Y
		bullet.bullet_direction = (-global_transform.basis.z).rotated(Vector3.UP, deg_to_rad(-90))
