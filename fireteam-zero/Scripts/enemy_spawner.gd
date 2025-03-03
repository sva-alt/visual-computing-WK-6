extends Node3D

@export var enemy_prefab: PackedScene
@export var root_node: Node3D
@export var spawn_rate: float = 0.2
var killed_enemies: int = 0
var curr_enemies: int = 0
var spawn_timer: float = 60.0
var dead_enemies_indx: Array = []


func _ready() -> void:
	spawn_timer = spawn_rate

func _process(delta: float) -> void:
	spawn_timer -= delta
	if (spawn_timer <= 0) && (curr_enemies < 15):
		spawn_timer = spawn_rate
		spawn_enemy()
	curr_enemies = get_child_count()
	for i in range(curr_enemies):
		if (get_child(i).current_health <= 0 && i not in dead_enemies_indx):
			killed_enemies += 1
			dead_enemies_indx.append(i)
			print(killed_enemies)
		
func spawn_enemy() -> void:
	if enemy_prefab and root_node:
		var enemy = enemy_prefab.instantiate()
		var rand_angle = randf_range(0, TAU) # TAU es igual a 2 * PI
		var spawn_distance = 20.0
		var offset = Vector3(cos(rand_angle), 0, sin(rand_angle)) * spawn_distance
		enemy.position = global_position + offset
		add_child(enemy)


	


func _on_child_exiting_tree(node: Node) -> void:
	dead_enemies_indx.pop_front()
