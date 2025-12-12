extends Node2D

# GENERICO --->
@onready var animacion = $cortina/AnimationPlayer
@onready var cortina = $cortina/curtains
@onready var player = %Player
@onready var collectables = $Parallax2D_medio/Collectables
@onready var hud = get_tree().get_current_scene().get_node("HudNivel")
@onready var player_respawn_points: Node2D = %player_respawn_points
# <--- GENERICOespawn_points

# SPEUDO GENERICO
# Los valores deberían dejarse en la instancia
@export var zona : String = "NIVEL 1 - ZONA B"
@export var nivel : String = "BAR 'BARRACUDA'"

@onready var spawn_point_0: Marker2D = %Portal_1/Marker2D
@onready var spawn_point_1: Marker2D = %Portal2a3/Marker2D


func _ready() -> void:
	GameState.clear_respawn_points()
	hud.update_items_slots_from_game_state()
	AudioManager.play_bar()

	# ESTO TAMBIEN HAY QUE GENERALIZARLO
	var spawn_point = spawn_point_0
	#

	# Conectar señales de todos los ítems iniciales
	for item in collectables.get_children():
		if item.has_signal("item_collected"):
			item.connect("item_collected", Callable(self, "_on_item_collected"))

	# ESTO DEBERMINA EN DONDE APARECE EL PLAYER
	# AL CARGAR LA ESCENA - TIENE QUE SER GENERICO
	# OJO QUE ACA CAMBIA CON RESPECTO A LEVEL 1 ZONA A
	if GameState.portal == 2:
		spawn_point = spawn_point_0
		player.global_position = spawn_point.global_position
		GameState.portal = 0
		print("valor de portal ahora")
		print(GameState.portal)
	elif GameState.portal == 3:
		spawn_point = spawn_point_1
		player.global_position = spawn_point.global_position
		GameState.portal = 0
		print("valor de portal ahora")
		print(GameState.portal)
	
	if hud:
		hud.actualizar_nivel_y_zona(zona, nivel )
	
	print("Animacion cortina entrada")
	animacion.play("entrada")
	animacion.animation_finished.connect(_on_animacion_terminada)
	
	# Conectamos la señales para cuando el player muere
	player.player_died.connect(respawn_player)
	player.game_over.connect(game_over)

func _on_animacion_terminada(anim_name: String) -> void:
	# habilitar movimiento jugador
	print("Animacion cortina "+anim_name+" finalizada")
	await get_tree().create_timer(0.7).timeout
	
	# ESTO SE PUEDE DESACTIVAR POR AHORA
	#if GameState.tutorial:
	#	# Desactivamos el tutorial para la próxima entrada del nivel
	#	GameState.tutorial = false
	#	print("INICIAR TUTORIAL")
	#	#init_tutorial()


func _process(_delta: float) -> void:
	if GameState.game_over:
		# Actualizamos el contador del TIMER para disparar
		# la secuencia de GAME OVER. Esto permite una pausa
		# desde el PLAYER MUERE para que no sea inmediato.
		if GameState.timer_game_over > 0:
			GameState.timer_game_over -= 1*_delta
		else:
			# Una vez alcanzado el TIMER verificamos 
			# si no se ha lanzado ya la secuencia para
			# no cortar el _process y que quede todo congelado.
			if not GameState.game_over_scene_launched:
				GameState.game_over_scene_launched = true
				GameState.text_loader = "DEUDA DE PLD EXTREMA"
				GameState.text_loader_subtitulo = "Liquidación..."
				GameState.image_loader_mini = "game_over"
				
				# OJO QUE ACA CAMBIA POR EL TEMA DEL BAR
				AudioManager.get_node("ost/Bar").stop()
				
				Sfx.sfx_play('loader_game_over')
				call_deferred("_change_to_loader")
	
	# ESTO SE PUEDE DESACTIVAR
	#GameState.tutorial = false	
	#if GameState.tutorial and GameState.tutorial_player_first_move:	
	#	timer_to_tutorial_first_move -= 1 * _delta	
	#	if timer_to_tutorial_first_move < 0:	
	#		GameState.tutorial_player_first_move = false	
	#		# DialogManager.			

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
		AudioManager.get_node("ost/Bar").stop()
		get_tree().change_scene_to_file("res://src/scenes/levels/loader.tscn")

# MANERO DE ITEMS COLECTADOS Y RESPAWN
func _on_item_collected(
	item_scene_path: String, 
	pos: Vector2, 
	item_type: String, 
	item_specimen: String, 
	respawn_time: float) -> void:
	
	print("🌀 Item recogido. Se respawneará en:", pos)
	print(" item type & specimen",item_type, item_specimen)
	
	if item_type == "bonus":
		Sfx.sfx_play('item_bonus')
	elif item_type == "mision":
		Sfx.sfx_play('item_mision')
	else:
		Sfx.sfx_play('item_puntos')
		
	await get_tree().create_timer(respawn_time).timeout
	
	# Instanciar de nuevo el ítem desde su escena original
	var scene = load(item_scene_path)
	if scene:
		var new_item = scene.instantiate()
		new_item.global_position = pos
		
		# reconectar su señal
		if new_item.has_signal("item_collected"):
			new_item.connect("item_collected", Callable(self, "_on_item_collected"))
		
		collectables.add_child(new_item)
		print("🍄 Item respawneado:", item_scene_path)

func respawn_player() -> void :
	print("RESPAWN PLAYER")
	# Paso 1: Cerramos cortina
	print("Animacion cortina salida")
	animacion.animation_finished.disconnect(_on_animacion_terminada)
	animacion.animation_finished.connect(respawn_player_paso_2)
	animacion.play("salida")

func respawn_player_paso_2(_anim_name: String) -> void :
	# NOTA TECNICA: no quitar el parámetro anima_name aunque no se use
	# porque falla el connect
	print("RESPAWN PLAYER - paso 2")
	cortina.color = Color(0,0,0,1)
	player.global_position = GameState.get_respawn_point(player, player_respawn_points)
	await get_tree().create_timer(0.3).timeout
	print("Animacion cortina entrada")
	animacion.play("entrada")
	animacion.animation_finished.disconnect(respawn_player_paso_2)
	animacion.animation_finished.connect(_on_animacion_terminada)

func player_captured() -> void:
	# Los NPC llaman a este método para avisar que han capturado al Player
	# Se pueden hacer algunas cosas, como vaciar en el HUD el inventario de USED
	# Mientras le pasamos al Player el estado de capturado para animación.
	hud.agregar_item(null,"used","")
	player.captured()

func game_over() -> void:
	print("GAME OVER")
	GameState.game_over = true

func give_player_quest_reward(player_quest_reward, player_quest_reward_pld) -> void:
	# Esto es muy cabeza, pero funciona. Hay que mejorarlo con sonido, etc.
	# Agregamos el OBJETO-PASE
	var texture:Texture2D = load("res://_assets/art/sprites/item_"+str(player_quest_reward)+".png")
	hud.agregar_item(texture, 'pass', player_quest_reward)
	hud.actualizar_puntos(GameState.pld+int(player_quest_reward_pld))
	# Quitamos el OBJETO-HISTORIA
	hud.agregar_item(null,"quest","")

func _input(event):
	if event.is_action_pressed("pause"):
		if not get_tree().paused:
			# Si el juego NO está pausado, llamamos a la función show_menu()
			PauseMenu.show_menu()
			get_viewport().set_input_as_handled()
