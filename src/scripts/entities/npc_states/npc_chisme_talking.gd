extends StateNPCs
class_name NpcChismeTalking

@onready var npc: CharacterBody2D = $"../.."

var player: CharacterBody2D
var dialog_number
var npc_dialogo
var dialog_started = false
var body_desactivated = false

func enter():
	print("NpcChismeTalking enter")
	npc.dialog_player_lost.connect(_on_dialog_player_lost)
	GameState.update_npc_property( npc, 'state', 'NpcChismeTalking' )

	dialog_number = GameState.get_npc_property( npc, 'dialog_number')
	npc_dialogo = npc.dialogo
	player = get_tree().get_first_node_in_group("player")
	
	start_dialog()

func exit():
	print("NpcTalking exit")
	npc.dialog_player_lost.disconnect(_on_dialog_player_lost)
	npc.is_talking = false

func update(_delta: float):
	if not body_desactivated:
		npc.velocity = Vector2.ZERO
		npc.body_collision_shape_2d.set_deferred('disabled',true)
		body_desactivated = true

func physics_update(_delta: float):
	pass

func _on_dialog_player_lost():
	print("NpcChismeTalking _on_dialog_player_lost")
	Transitioned.emit(self, "NpcChismeWaiting")

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
		npc_dialogo.update_text("¡Hola! Los 'honguitos'\n son fantásticos, pero\n mucho mejor son\n los 'chupachups'")
		npc_dialogo.visible = true
		npc.is_talking = true
		await get_tree().create_timer(1.8).timeout
		
		# 🔵 ETAPA 1 → PLAYER HABLA
		player.play_dialog("No se quién \nte preguntó, pero\n gracias por el dato")
		player.dialogo.visible = true
		npc_dialogo.visible = false  # NPC callado
		npc.is_talking = false
		await get_tree().create_timer(1.3).timeout
		
		dialog_number = 1
		
	else:

		player.dialogo.visible = false   # player callado
		npc_dialogo.update_text("Se consiguen \nmás alto \n¡blurp blurp!")
		npc_dialogo.visible = true
		npc.is_talking = true
		await get_tree().create_timer(1.5).timeout
		
		dialog_number = 0 # con esto lo hacemos ciclico
		
	GameState.update_npc_property(npc, 'dialog_number', dialog_number)
	end_dialog()

func end_dialog():
	# Ocultar ambos
	player.dialogo.visible = false
	npc_dialogo.visible = false
	npc.is_talking = false
	
	player.is_talking = false
	npc.set_process(true)
	
	dialog_started = false
	#queue_free() # Esto lo quejamos sin efecto para repetir los dialogos.
	
	Transitioned.emit(self, "NpcChismeWaiting") # Esto deberia ser NpcQuestWaiting
