extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	pass


func _on_volver_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func _on_check_box_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0,toggled_on)
	pass # Replace with function body.


#func _on_option_button_item_selected(index: int) -> void:
#	match index:
#		0:
#			DisplayServer.window_set_size(Vector2i(854,480))
#		1:
#			DisplayServer.window_set_size(Vector2i(1280,720))	
#		2:
#			DisplayServer.window_set_size(Vector2i(1920,1080))	
#		3:
#			DisplayServer.window_set_size(Vector2i(2560,1440))	
	
