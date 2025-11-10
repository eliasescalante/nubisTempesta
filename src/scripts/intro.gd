extends VideoStreamPlayer


func _ready():
	pass

func _process(delta: float) -> void:
	pass

func _on_finished() -> void:
	get_tree().change_scene_to_file("res://src/scenes/levels/level_1.tscn")
	pass # Replace with function body.


func _on_button_pressed() -> void:
	stop()
	get_tree().change_scene_to_file("res://src/scenes/levels/level_1.tscn")
	pass # Replace with function body.
