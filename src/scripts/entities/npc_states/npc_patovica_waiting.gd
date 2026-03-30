extends StateNPCs
class_name NpcPatovicaWaiting

@onready var npc: CharacterBody2D = $"../.."
@onready var state

var player: CharacterBody2D
var body_desactivated = false
var hud
var control_point: Node
var target_desired
var target_pld_desired
var object_pass_specimen

func enter():
	print("NpcPatovicaWaiting enter")
	hud = get_tree().get_root().find_child("HudNivel", true, false)
	state = GameState.get_npc_state(npc)
	control_point = npc.return_point
	control_point.player_detected.connect(_on_control_point_player_detected)
	# NO CONECTAR ACA EL DIALOGO
	#DialogManager.current_dialog_finished.connect(_on_current_dialog_finished)
	target_desired = GameState.get_npc_property( npc, 'target_desired')
	print("target_desired ",target_desired)
	target_pld_desired = GameState.get_npc_property( npc, 'target_pld_desired')
	print("target_pld_desired ",target_pld_desired)

	body_desactivated = false
	player = get_tree().get_first_node_in_group("player")
	GameState.update_npc_property( npc, 'state', 'NpcPatovicaWaiting' )

func exit():
	print("NpcPatovicaWaiting exit")
	control_point.player_detected.disconnect(_on_control_point_player_detected)
	DialogManager.current_dialog_finished.disconnect(_on_current_dialog_finished)
	
func update(_delta: float):
	if not body_desactivated:
		print("Desactivamos el bloqueo de paso")
		npc.velocity = Vector2.ZERO
		npc.body_collision_shape_2d.set_deferred('disabled',true)
		body_desactivated = true

func physics_update(_delta: float):
	pass

func _on_current_dialog_finished():
	print("NpcPatovicaWaiting _on_current_dialog_finished")
	pass_completed_end_dialog()

func _on_control_point_player_detected():
	print("NpcPatovicaWaiting _on_return_point_player_detected")
	# Acá nos avisa el control_point que el Player ha pasado
	print("Comprobar si cumple los requisitos para pasar o no")
	print("target_desired ",target_desired)
	
	if target_pld_desired:
		print("Es INT, una cantidad de PLD específica,")
		print("por lo tanto actuamos con la lógica de PATOVICA-PLD")
		print("GameState.pld ", int(GameState.pld))
		if  int(GameState.pld) < target_pld_desired:
			await get_tree().create_timer(0.25).timeout
			Transitioned.emit(self, "NpcPatovicaTalking")
		else:
			# forzamos a que se vuelva a desactivar por las dudas
			body_desactivated = false
		return
	if target_desired:
		print("Es STRING, la especia de OBJETO DE DESEO específico,")
		print("por lo tanto actuamos con la lógica de PATOVICA-PASS")
		object_pass_specimen = hud.object_pass_specimen
		if target_desired != object_pass_specimen:
			Transitioned.emit(self, "NpcPatovicaTalking")
		else:
			# Aquí tenemos que activar la secuencia de PASS-COMPLETED:
			# 1. Disparar un diálogo de patovica-x-completed
			# 2. Consumir el OBJETO PASS
			# 3. Desactivar al NPC
			DialogManager.current_dialog_finished.connect(_on_current_dialog_finished)
			pass_completed_start_dialog()
		return
	
	print("***************************************************")
	print("ATENCION")
	print("El tipo de dato del 'target_desired' no se reconoce")
	print("ADVERTENCIA: el NPC puede quedar bloqueado")
	print("Por las dudas lo desactivamos")
	print("***************************************************")
	Transitioned.emit(self, "NpcDesactivated")
	

func pass_completed_start_dialog():
	print("# 1. Disparar un diálogo de patovica-x-completed")
	var npc_dialog_id = npc.dialog_id+"-completed"
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
		print("***************************************************")
		print("ATENCION")
		print("No hay más secuencias de diálogo disponibles, PERO")
		print("Se supone que en este punto el NPC-PATOVICA-PASS")
		print("ya estaba COMPLETED.")
		print("***************************************************")
		pass_completed_end_dialog()

func pass_completed_end_dialog():
	print("# 2. Consumir el OBJETO PASS")
	# Quitamos el OBJETO-HISTORIA
	hud.agregar_item(null,"pass","")
	print("# 3. Desactivar al NPC")
	# Marcamos la mision como cumplida
	GameState.update_npc_property(npc, 'quest', true)
	Transitioned.emit(self, "NpcDesactivated")
