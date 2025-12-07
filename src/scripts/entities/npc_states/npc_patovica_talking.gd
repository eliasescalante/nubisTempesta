extends StateNPCs
class_name NpcPatovicaTalking

@onready var npc: CharacterBody2D = $"../.."

var player: CharacterBody2D
var dialog_number
var npc_dialogo
var target_desired
var dialog_started = false
var body_activated = false

func enter():
	print("NpcPatovicaTalking enter")
	npc.dialog_player_lost.connect(_on_dialog_player_lost)
	GameState.update_npc_property( npc, 'state', 'NpcPatovicaTalking' )

	dialog_number = GameState.get_npc_property( npc, 'dialog_number')
	npc_dialogo = npc.dialogo # Referenciamos el nodo de dialogo
	target_desired = GameState.get_npc_property( npc, 'target_desired')
	player = get_tree().get_first_node_in_group("player")
	body_activated = false
	start_dialog()

func exit():
	print("NpcPatovicaTalking exit")
	npc.dialog_player_lost.disconnect(_on_dialog_player_lost)
	npc.is_talking = false

func update(_delta: float):
	if not body_activated:
		print("HABILITAMOS BLOQUEO")
		npc.velocity = Vector2.ZERO
		npc.body_collision_shape_2d.set_deferred('disabled',false)
		body_activated = true

func physics_update(_delta: float):
	pass

func _on_dialog_player_lost():
	print("NpcPatovicaTalking _on_dialog_player_lost")
	#Transitioned.emit(self, "NpcChismeWaiting")
	# POR AHORA NO HACEMOS NADA. LO MANTENEMOS SIMPLE

# ------------------------------------------------------------------------------
# AQUI SE TIENE QUE OPTIMIZAR LA SECUENCIA DE DIALOGOS USANDO UN ARRAY Y LISTA
# MEJORAR LOS METODOS PARA ALTERNAR LA VISIBILIDAD DE LOS GLOBOS.

func start_dialog():
	dialog_started = true

	# Bloquear ambos
	npc.set_process(false)
	player.is_talking = true

	if dialog_number == 0:
		
		player.dialogo.visible = false   # player callado
		player.is_talking = false
		npc_dialogo.update_text("Alto, necesitás \n"+target_desired+" PLD \n para pasar. \n Tomátelas")
		npc_dialogo.visible = true
		npc.is_talking = true
		await get_tree().create_timer(1.8).timeout
		
		# 🔵 ETAPA 1 → PLAYER HABLA
		player.play_dialog("¡Uh,  que pesado!")
		player.dialogo.visible = true
		player.is_talking = true
		npc_dialogo.visible = false  # NPC callado
		npc.is_talking = false
		await get_tree().create_timer(1.3).timeout
		
		dialog_number = 1
		
	else:
		dialog_number += 1
		print("dialog_number ",dialog_number)
		await get_tree().create_timer(0.25).timeout
		
	if  dialog_number > 3:
		# NPC HABLA
		player.dialogo.visible = false   # player callado
		player.is_talking = false
		npc_dialogo.update_text("¿Te falla el coco? \n"+target_desired+" PLD \n ¡o a volar!")
		npc_dialogo.visible = true
		npc.is_talking = true
		await get_tree().create_timer(1.5).timeout
		
		# PLAYER HABLA
		player.play_dialog("¡GRRRRR!")
		player.dialogo.visible = true
		player.is_talking = true
		npc_dialogo.visible = false  # NPC callado
		npc.is_talking = false
		await get_tree().create_timer(0.7).timeout
		
		dialog_number = 0 # con esto lo hacemos ciclico
		
	GameState.update_npc_property(npc, 'dialog_number', dialog_number)
	end_dialog()

func end_dialog():
	# Ocultar ambos
	player.dialogo.visible = false
	player.is_talking = false
	npc_dialogo.visible = false
	npc.is_talking = false
	npc.set_process(true)
	dialog_started = false
	#queue_free() # Esto lo quejamos sin efecto para repetir los dialogos.
	
	Transitioned.emit(self, "NpcPatovicaBlocking") # Esto deberia ser NpcQuestWaiting
