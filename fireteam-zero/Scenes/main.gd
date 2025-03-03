extends Node3D

@onready var target = $Player

var starting_nodes : int
var current_nodes : int
var current_wave : int
var wave_spawned_ended

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_wave = 0
	Global.current_wave = current_wave
	starting_nodes = get_child_count()
	current_nodes = get_child_count()
	position_to_next_wave()

func position_to_next_wave():
	if current_nodes == starting_nodes:
		if current_wave != 0:
			Global.moving_to_next_wave = true
		current_wave += 1
		Global.current_wave = current_wave
		print(current_wave)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_tree().call_group("Enemy","target_position", target.global_transform.origin)
	update_score()
	if !Global.playerAlive:
		print('YOU ARE DEAD')
	pass

func update_score() -> void :
	Global.previous_score = Global.current_score
	if Global.current_score > Global.high_score:
		Global.high_score = Global.current_score
	if !Global.playerAlive:
		Global.current_score = 0
