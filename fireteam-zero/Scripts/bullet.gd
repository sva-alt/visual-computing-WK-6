extends Node3D

@export var bullet_speed: float = 50.0
var bullet_direction: Vector3 = Vector3.ZERO

func _ready():
	# Destruir la bala después de 5 segundos
	var timer = $Timer
	timer.wait_time = 5
	timer.one_shot = true
	timer.start()
	timer.timeout.connect(queue_free)  # Conectar correctamente la señal

func _process(delta):
	if bullet_direction != Vector3.ZERO:
		position += bullet_direction.normalized() * bullet_speed * delta
