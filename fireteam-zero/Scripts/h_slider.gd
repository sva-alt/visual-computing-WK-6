extends HSlider

@export
var bus_name: String

var bus_index: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get the index of the audio bus with the given name.
	bus_index = AudioServer.get_bus_index("Master")
	
	# Check if the bus index is valid.
	if bus_index == -1:
		push_error("Audio bus not found: " + bus_name)
		return
	
	# Connect the value_changed signal to the _on_value_changed function.
	value_changed.connect(_on_value_changed)
	
# Called when the value of the slider changes.
func _on_value_changed(value: float) -> void:
	# Check if the bus index is valid before setting the volume.
	if bus_index == -1:
		return
		
	# Convert the linear value to decibels and set the bus volume.
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
