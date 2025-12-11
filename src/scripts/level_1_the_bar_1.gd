extends Node2D

@onready var hud = get_tree().get_current_scene().get_node("HudNivel")
@export var zona : String = "NIVEL 1 - ZONA B"
@export var nivel : String = "BAR 'BARRACUDA'"

func _ready() -> void:
	AudioManager.play_bar()
	var player = %Player
	if GameState.portal == 2:
		var spawn_point = %Portal_1/Marker2D
		player.global_position = spawn_point.global_position
		GameState.portal = 0
		print("valor de portal ahora")
		print(GameState.portal)
	elif GameState.portal == 3:
		var spawn_point = %Portal2a3/Marker2D
		player.global_position = spawn_point.global_position
		GameState.portal = 0
		print("valor de portal ahora")
		print(GameState.portal)
	
	if hud:
		hud.actualizar_nivel_y_zona(zona, nivel )

func _process(delta: float) -> void:
	pass

func _on_portal_1a_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameState.portal = 1
		GameState.loader = 2
		GameState.text_loader = "NIVEL 1 - ZONA A"
		GameState.text_loader_subtitulo = "BAJOS PILARES"
		GameState.image_loader_mini = "nivel_1_zona_a"
		print(GameState.portal)
		AudioManager.get_node("ost/Bar").stop()
		get_tree().change_scene_to_file("res://src/scenes/levels/loader.tscn")

func _on_portal_2a_3_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		# AQUÍ HAY QUE PONER EL FINAL DEL DEMO
		GameState.portal = 3
		GameState.loader = 3
		GameState.text_loader = "NIVEL 1 - ZONA C"
		GameState.text_loader_subtitulo = "TERRAZAS ALZADAS"
		GameState.image_loader_mini = "nivel_1_zona_c"
		print(GameState.portal)
		get_tree().change_scene_to_file("res://src/scenes/levels/loader.tscn")

func _input(event):
	if event.is_action_pressed("pause"):
		if not get_tree().paused:
			# Si el juego NO está pausado, llamamos a la función show_menu()
			PauseMenu.show_menu()
			get_viewport().set_input_as_handled()
