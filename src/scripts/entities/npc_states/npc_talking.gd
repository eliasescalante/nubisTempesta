extends StateNPCs
class_name NpcTalking

@onready var npc: CharacterBody2D = $"../.."
@onready var player: CharacterBody2D

# Todos estos creo que se borran porque los va a administrar el DIALOG_DIRECTOR
# --------------------------->
var dialog_number
var npc_dialogo

# <---------------------------

var dialog_started = false
var dialog_finished = false

@onready var target_desired
@onready var npc_dialog_id

func enter():
	print("NpcTalking enter")
	npc.dialog_player_lost.connect(_on_dialog_player_lost)
	GameState.update_npc_property( npc, 'state', 'NpcTalking' )

	dialog_number = GameState.get_npc_property( npc, 'dialog_number')
	target_desired = GameState.get_npc_property( npc, 'target_desired')
	npc_dialogo = npc.dialogo
	npc_dialog_id = npc.dialog_id
	if npc_dialog_id == "":
		npc_dialog_id = 'npc-estorbo'
	player = get_tree().get_first_node_in_group("player")

func exit():
	print("NpcTalking exit")
	npc.dialog_player_lost.disconnect(_on_dialog_player_lost)
	npc.is_talking = false

func update(_delta: float ):
	if not dialog_started:
		dialog_started = true
		start_dialog()
	else:
		dialog_finished = DialogManager.is_current_dialog_finished
		if dialog_finished:
			end_dialog()

func physics_update(_delta: float):
	pass

func _on_dialog_player_lost():
	print("NpcTalking _on_dialog_player_lost")
	Transitioned.emit(self, "NpcQuestWaiting")

# ------------------------------------------------------------------------------
# AQUI SE TIENE QUE OPTIMIZAR LA SECUENCIA DE DIALOGOS USANDO UN ARRAY Y LISTA
# MEJORAR LOS METODOS PARA ALTERNAR LA VISIBILIDAD DE LOS GLOBOS.

func start_dialog():
	
	var the_dialog_sequence = DialogManager.get_dialog_sequence(npc_dialog_id)
	
	if not the_dialog_sequence.is_empty():
		DialogManager.dialog_director(
			the_dialog_sequence,
			{ # 'actors'
				'player': player,
				'npc': npc
			},
			{ # 'replacements'
				'<%OBJ%>': str(target_desired)
			}
		)
	else:
		# Si no hay más diálogo vamos al estado de Waiting
		end_dialog()
		
func end_dialog():
	Transitioned.emit(self, "NpcQuestWaiting") # Esto deberia ser NpcQuestWaiting
