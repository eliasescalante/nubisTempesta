extends StateNPCs
class_name NpcChismeTalking

@onready var npc: CharacterBody2D = $"../.."
@onready var player: CharacterBody2D

var dialog_started = false
var dialog_finished = false

@onready var target_desired
@onready var npc_dialog_id
var body_desactivated = false

func enter():
	print("NpcChismeTalking enter")
	
	# Conectamos con la señales que intervienen en cambios de estado
	npc.dialog_player_lost.connect(_on_dialog_player_lost)
	DialogManager.current_dialog_finished.connect(_on_current_dialog_finished)
	
	# Actualizamos el GameState para este NPC
	GameState.update_npc_property( npc, 'state', 'NpcChismeTalking' )

	# Referenciamos el resto de las entidades
	npc_dialog_id = npc.dialog_id
	if npc_dialog_id == "":
		npc_dialog_id = 'chisme'
	player = get_tree().get_first_node_in_group("player")
	
	# Ponemos el flag 'dialog_started = false' para indicar
	# que se puede iniciar el dialogo en el proximo process update
	# NOTA: esto es importante para las repeticiones.
	dialog_started = false

func exit():
	print("NpcTalking exit")
	npc.dialog_player_lost.disconnect(_on_dialog_player_lost)
	DialogManager.current_dialog_finished.disconnect(_on_current_dialog_finished)

func update(_delta: float):
	if not body_desactivated:
		npc.velocity = Vector2.ZERO
		npc.body_collision_shape_2d.set_deferred('disabled',true)
		body_desactivated = true
	if not dialog_started:
		print("Iniciar Diálogo...")
		dialog_started = true
		start_dialog()
func physics_update(_delta: float):
	pass

# Funciones conectadas a las señales
func _on_dialog_player_lost():
	print("NpcChismeTalking _on_dialog_player_lost")
	Transitioned.emit(self, "NpcChismeWaiting")

func _on_current_dialog_finished():
	print("NpcChismeTalking on_current_dialog_finished")
	Transitioned.emit(self, "NpcChismeWaiting")

# ------------------------------------------------------------------------------
# AQUI SE TIENE QUE OPTIMIZAR LA SECUENCIA DE DIALOGOS USANDO UN ARRAY Y LISTA
# MEJORAR LOS METODOS PARA ALTERNAR LA VISIBILIDAD DE LOS GLOBOS.

func start_dialog():
	
	print("Obtenemos la secuencia de diálogo para:", npc_dialog_id)
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
				'<%OBJ%>': str(target_desired)
			}
		)
	else:
		print("No hay más secuencias de diálogo disponibles. Finalizar diálogo.")
		# Si no hay más diálogo vamos al estado de Waiting
		Transitioned.emit(self, "NpcDesactivating")
		
func end_dialog():
	Transitioned.emit(self, "NpcChismeWaiting")
