extends StateNPCs
class_name NpcPatovicaTalking

@onready var npc: CharacterBody2D = $"../.."
@onready var player: CharacterBody2D

var dialog_started = false
var dialog_finished = false

var target_desired
var target_pld_desired
var npc_dialog_id

var body_activated = false

func enter():
	print("NpcPatovicaTalking enter")
	GameState.update_npc_property( npc, 'state', 'NpcPatovicaTalking' )
		
	npc.dialog_player_lost.connect(_on_dialog_player_lost)
	DialogManager.current_dialog_finished.connect(_on_current_dialog_finished)

	target_desired = GameState.get_npc_property( npc, 'target_desired')
	print("target_desired ",target_desired)
	target_pld_desired = GameState.get_npc_property( npc, 'target_pld_desired')
	print("target_pld_desired ",target_pld_desired)
	
	npc_dialog_id = npc.dialog_id
	if npc_dialog_id == "":
		npc_dialog_id = 'patovica-1'
		
	player = get_tree().get_first_node_in_group("player")
	
	body_activated = false
	dialog_started = false

func exit():
	print("NpcPatovicaTalking exit")
	npc.dialog_player_lost.disconnect(_on_dialog_player_lost)
	DialogManager.current_dialog_finished.disconnect(_on_current_dialog_finished)
	npc.is_talking = false

func update(_delta: float):
	if not body_activated:
		print("HABILITAMOS BLOQUEO")
		npc.velocity = Vector2.ZERO
		npc.body_collision_shape_2d.set_deferred('disabled',false)
		body_activated = true
	if not dialog_started:
		print("Iniciar Diálogo...")
		dialog_started = true
		start_dialog()

func physics_update(_delta: float):
	pass

func _on_dialog_player_lost():
	print("NpcPatovicaTalking _on_dialog_player_lost")
	end_dialog()

func _on_current_dialog_finished():
	print("NpcPatovicaTalking _on_current_dialog_finished")
	end_dialog()

# ------------------------------------------------------------------------------
func start_dialog():
	print("Obtenemos la secuencia de diálogo")
	var the_dialog_sequence = DialogManager.get_dialog_sequence(npc_dialog_id)
	print("the_dialog_sequence ",the_dialog_sequence)
	if not the_dialog_sequence.is_empty():
		print("Invocamos al método DIALOG_DIRECTOR")
		var replacements
		if target_pld_desired:
			replacements = { # 'replacements'
				'<%OBJ%>': str(target_pld_desired)
			}
		else:
			replacements = { # 'replacements'
				'<%OBJ%>': str(target_desired)
			}
		DialogManager.dialog_director(
			the_dialog_sequence,
			{ # 'actors'
				'player': player,
				'npc': npc
			},
			replacements
		)
	else:
		print("No hay más secuencias de diálogo disponibles. Finalizar diálogo.")
		# Si no hay más diálogo vamos al estado de Waiting
		end_dialog()

func end_dialog():
	Transitioned.emit(self, "NpcPatovicaBlocking") # Esto deberia ser NpcQuestWaiting
