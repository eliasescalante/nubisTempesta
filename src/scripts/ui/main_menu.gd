extends Control

class_name MainMenu


func _on_play_button_pressed() -> void:
	#LevelManager.load_level(3)
	get_tree().change_scene_to_file("res://src/scenes/levels/test_scene_level_01.tscn")
	AudioManager.get_node("ost/Introduccion").stop()
	deactivate()


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func deactivate() -> void:
	hide()
	set_process(false)
	set_process_unhandled_input(false)
	set_process_input(false)
	set_physics_process(false)


func activate() -> void:
	show()
	set_process(true)
	set_process_unhandled_input(true)
	set_process_input(true)
	set_physics_process(true)


func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/levels/creditos.tscn")
	pass # Replace with function body.
