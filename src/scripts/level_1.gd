extends Node2D

@onready var animacion = $cortina/AnimationPlayer
@onready var cortina = $cortina/curtains
@onready var player = %Player
@onready var collectables = $Parallax2D_medio/Collectables
@onready var hud = get_tree().get_current_scene().get_node("HudNivel")
@onready var player_respawn_points: Node2D = %player_respawn_points

@export var zona : String = "NIVEL 1 - ZONA A"
@export var nivel : String = "BAJOS PILARES"

# @export var respawn_time: float = 1.0 # segundos para reaparecer
# esto ahora forma parte del item 

@onready var spawn_point_0: Marker2D = %Portal0/Marker2D
@onready var spawn_point_1: Marker2D = %Portal1/Marker2D

@onready var timer_to_tutorial_first_move:float = 3.0

func _ready() -> void:
	AudioManager.play_nivel_1()
	var spawn_point = spawn_point_0
	#
	#print("### TEST DIALOGO ")
	#for d in range(11):
	#	print("d ",d," ", DialogManager.get_dialog_sequence('test_dialog'))
	#	print("d ",d," ", DialogManager.get_dialog_sequence('tutorial_1'))
	#	
	# Conectar señales de todos los ítems iniciales
	for item in collectables.get_children():
		if item.has_signal("item_collected"):
			item.connect("item_collected", Callable(self, "_on_item_collected"))
	
	if GameState.portal == 1:
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
	
	player.player_died.connect(respawn_player)
	

func _on_animacion_terminada(anim_name: String) -> void:
	# habilitar movimiento jugador
	print("Animacion cortina "+anim_name+" finalizada")
	await get_tree().create_timer(0.7).timeout
	if GameState.tutorial:
		# Desactivamos el tutorial para la próxima entrada del nivel
		GameState.tutorial = false
		print("INICIAR TUTORIAL")
		#init_tutorial()

	
func _process(_delta: float) -> void:
	GameState.tutorial = false
	if GameState.tutorial and GameState.tutorial_player_first_move:
		timer_to_tutorial_first_move -= 1 * _delta
		if timer_to_tutorial_first_move < 0:
			GameState.tutorial_player_first_move = false
			# DialogManager.
func _on_portal_1_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameState.portal = 2
		GameState.loader = 1
		GameState.text_loader = "NIVEL 1 - ZONA B"
		GameState.text_loader_subtitulo = "BAR 'BARRACUDA'"
		GameState.image_loader_mini = "nivel_1_zona_b"
		print(GameState.portal)
		AudioManager.get_node("ost/Nivel1").stop()
		call_deferred("_change_to_loader")

func _change_to_loader():
	get_tree().change_scene_to_file("res://src/scenes/levels/loader.tscn")

func _on_item_collected(item_scene_path: String, pos: Vector2, item_type: String, item_specimen: String, respawn_time: float) -> void:
	
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

func respawn_player_paso_2(anim_name: String) -> void :
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
