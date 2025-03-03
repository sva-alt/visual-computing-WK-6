extends Node3D

@onready var target = $Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
