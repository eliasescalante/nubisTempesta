extends CanvasLayer

@onready var panel = $Panel

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

func show_menu():
	#muestro el menu y pauso el juego
	visible = true
	get_tree().paused = true
	panel.grab_focus()
	print("MENU PAUSA ACTIVADO")


func hide_menu():
	#oculto el menu y saco la pausa a la familia de nodos
	visible = false
	get_tree().paused = false
	print("MENU PAUSA CERRADO")


func _input(event):
	#capturo el eventito del enter
	if visible and event.is_action_pressed("pause"):
		hide_menu()
		get_viewport().set_input_as_handled() 


func _on_resume_pressed() -> void:
	hide_menu()


func _on_exit_pressed() -> void:
	#get_tree().quit()
	hide_menu()
	AudioManager.stop_nivel_1() # Esto es HARDCODEDADO hay que hacer que pause el nivel actual.
	GameState.reset_game_state()
	get_tree().change_scene_to_file("res://src/scenes/main.tscn")
