extends Node3D

@export var enemy_prefab: PackedScene
@export var root_node: Node3D
@export var spawn_rate: float = 1.0

var spawn_timer: float = 0.0

func _ready() -> void:
	spawn_timer = spawn_rate

func _process(delta: float) -> void:
	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_timer = spawn_rate
		spawn_enemy()

func spawn_enemy() -> void:
	if enemy_prefab and root_node:
		var enemy = enemy_prefab.instantiate()
		var rand_angle = randf_range(0, TAU) # TAU es igual a 2 * PI
		var spawn_distance = 20.0
		var offset = Vector3(cos(rand_angle), 0, sin(rand_angle)) * spawn_distance
		enemy.position = global_position + offset
		root_node.add_child(enemy)
