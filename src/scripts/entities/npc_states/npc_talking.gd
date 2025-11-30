extends StateNPCs
class_name NpcTalking

@export var npc: CharacterBody2D

#-------------------------------------------------------------------------------
# NOTA En esta versión del juego 
# cada vez que hay dialogo los personajes están quietos
# pero a futuro se podrían mover.
@export var move_speed: float = 0.0
var move_direction := Vector2.ZERO
var change_direction: float = 0.0
#-------------------------------------------------------------------------------

var player: CharacterBody2D
var dialog_number
var npc_dialogo
var dialog_started = false
var target_desired

func enter():
	print("NpcTalking enter")
	npc.dialog_player_lost.connect(_on_dialog_player_lost)
	GameState.update_npc_property( npc, 'state', 'NpcTalking' )

	dialog_number = GameState.get_npc_property( npc, 'dialog_number')
	target_desired = GameState.get_npc_property( npc, 'target_desired')
	npc_dialogo = npc.dialogo
	player = get_tree().get_first_node_in_group("player")
	
	start_dialog()

func exit():
	print("NpcTalking exit")
	npc.dialog_player_lost.disconnect(_on_dialog_player_lost)
	npc.is_talking = false

func update(delta: float ):
	pass

func physics_update(_delta: float):
	pass

func _on_dialog_player_lost():
	print("NpcTalking _on_dialog_player_lost")
	Transitioned.emit(self, "NpcBlocking")

# ------------------------------------------------------------------------------
# AQUI SE TIENE QUE OPTIMIZAR LA SECUENCIA DE DIALOGOS USANDO UN ARRAY Y LISTA
# MEJORAR LOS METODOS PARA ALTERNAR LA VISIBILIDAD DE LOS GLOBOS.

func start_dialog():
	dialog_started = true

	# Bloquear ambos
	npc.set_process(false)
	player.is_talking = true

	if dialog_number == 0:
		# 🔵 ETAPA 1 → PLAYER HABLA
		player.play_dialog("Necesito pasar...")
		player.dialogo.visible = true
		npc_dialogo.visible = false  # NPC callado
		await get_tree().create_timer(1.5).timeout

		# 🔵 ETAPA 2 → NPC HABLA
		player.dialogo.visible = false   # player callado
		npc_dialogo.update_text("mmmm, quiero un "+target_desired+"...")
		npc_dialogo.visible = true
		await get_tree().create_timer(1.5).timeout
		
		GameState.update_npc_property(npc, 'quest', true)
		dialog_number = 1
		
	else:
		# 🔵 ETAPA 3 → NPC HABLA
		player.dialogo.visible = false   # player callado
		npc_dialogo.update_text(""+target_desired+" he dicho...")
		npc_dialogo.visible = true
		await get_tree().create_timer(1.5).timeout
		dialog_number = 2
	GameState.update_npc_property(npc, 'dialog_number', dialog_number)
	end_dialog()

func end_dialog():
	# Ocultar ambos
	player.dialogo.visible = false
	npc_dialogo.visible = false

	player.is_talking = false
	npc.set_process(true)
	
	dialog_started = false
	#queue_free() # Esto lo quejamos sin efecto para repetir los dialogos.
	
	Transitioned.emit(self, "NpcBlocking") # Esto deberia ser NpcQuestWaiting
