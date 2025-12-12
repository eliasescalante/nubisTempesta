extends StateNPCs
class_name NpcHistoriaQuestCompleted

@onready var npc: CharacterBody2D = $"../.."
@onready var player: CharacterBody2D

var dialog_started = false
var dialog_finished = false
var reward_quest_completed: String
var reward_quest_completed_pld: int
var level_node: Node
@onready var target_desired
@onready var npc_dialog_id

func enter():
	print("NpcHistoriaQuestCompleted enter")
	
	GameState.update_npc_property( npc, 'state', 'NpcHistoriaQuestCompleted' )

	# Conectamos con la señales que intervienen en
	# cambios de estado
	npc.dialog_player_lost.connect(_on_dialog_player_lost)
	DialogManager.current_dialog_finished.connect(_on_current_dialog_finished)

	target_desired = GameState.get_npc_property( npc, 'target_desired')
	reward_quest_completed = npc.reward_quest_completed
	reward_quest_completed_pld = npc.reward_quest_completed_pld
	
	# Referenciar al nodo del nivel para disparar la captura del player
	level_node = get_tree().get_first_node_in_group("levels")
	
	npc_dialog_id = npc.dialog_id
	if npc_dialog_id == "":
		npc_dialog_id = 'historia-1'
	npc_dialog_id += "-completed"
	
	player = get_tree().get_first_node_in_group("player")
	
	# Ponemos el flag 'dialog_started = false' para indicar
	# que se puede iniciar el dialogo en el proximo process update
	# NOTA: esto es importante para las repeticiones.
	dialog_started = false

func exit():
	print("NpcHistoriaQuestCompleted exit")
	npc.dialog_player_lost.disconnect(_on_dialog_player_lost)
	DialogManager.current_dialog_finished.disconnect(_on_current_dialog_finished)
	npc.is_talking = false

func update(_delta: float ):
	if not dialog_started:
		print("Iniciar Diálogo...")
		dialog_started = true
		start_dialog()

func physics_update(_delta: float):
	pass

func _on_dialog_player_lost():
	print("NpcHistoriaQuestCompleted _on_dialog_player_lost")
	#end_dialog()

func _on_current_dialog_finished():
	print("NpcHistoriaQuestCompleted on_current_dialog_finished")
	end_dialog()

# ------------------------------------------------------------------------------
# AQUI SE TIENE QUE OPTIMIZAR LA SECUENCIA DE DIALOGOS USANDO UN ARRAY Y LISTA
# MEJORAR LOS METODOS PARA ALTERNAR LA VISIBILIDAD DE LOS GLOBOS.

func start_dialog():
	
	print("Obtenemos la secuencia de diálogo")
	var the_dialog_sequence = DialogManager.get_dialog_sequence(npc_dialog_id)
	print("the_dialog_sequence ",the_dialog_sequence)
	if not the_dialog_sequence.is_empty():
		print("Invocamos al método DIALOG_DIRECTOR")
		DialogManager.dialog_director(
			the_dialog_sequence,
			{ # 'actors'
				'player': player,
				'npc': npc
			},
			{ # 'replacements'
				'<%OBJ%>': str(target_desired),
				'<%REW%>': str(reward_quest_completed),
				'<%PLD%>': str(reward_quest_completed_pld)
			}
		)
	else:
		print("No hay más secuencias de diálogo disponibles. Finalizar diálogo.")
		# Si no hay más diálogo vamos al estado de Waiting
		end_dialog()
		
func end_dialog():
	# Acá ponemos la recompensa por completar el Encargo/Misión de la Historia
	# El Player obtiene el objeto PASE y PLD.
	level_node.give_player_quest_reward(reward_quest_completed, reward_quest_completed_pld)
	# Marcamos la mision como cumplida
	GameState.update_npc_property(npc, 'quest', true)
	Transitioned.emit(self, "NpcDesactivated") # Esto deberia ser NpcQuestWaiting
