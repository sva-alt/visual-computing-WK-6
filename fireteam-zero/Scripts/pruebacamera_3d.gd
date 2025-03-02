extends Camera3D

@export

var max_shake_strength : float
var current_shake_strength : float

@export
var shake_fallout : float

@onready
var rand_gen = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func shake_camera():
	current_shake_strength - max_shake_strength
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	h_offset = rand_gen.randf_range(-current_shake_strength,current_shake_strength)
	v_offset = rand_gen.randf_range(-current_shake_strength,current_shake_strength)
	
	current_shake_strength = lerpf(current_shake_strength, 0 , delta*shake_fallout)
	pass
