extends Node

# Aquí vamos guardando los Diálogos ejecutados
# Para controlar la repetición de los mismos
var dialogues_performed = {}

func get_dialog_sequence(key_entity:String) -> Array:
	
	var dialogos_script = DiagloData.dialogos_script
	var current_repeat
	var current_sequence
	var saynomore
	
	if not dialogues_performed.has(key_entity):
		print ("Registrar ejecución de la SECUENCIA DE DIALOGO por ENTITY ",key_entity)
		
		dialogues_performed[key_entity] = {
			'repeat': 0,
			'current_sequence': 0,
			'saynomore': false,
		}
		
	current_repeat = dialogues_performed[key_entity]['repeat']
	current_sequence = dialogues_performed[key_entity]['current_sequence']
	saynomore = dialogues_performed[key_entity]['saynomore']
	
	print('current_repeat ',current_repeat)
	print('current_sequence ',current_sequence)
	print('saynomore ',saynomore)
	
	if saynomore:
		print("SAY NO MORE! - NO HAY MÁS DIÁLOGO")
		return []
	
	#---atributos---
	var the_dialogue_entity = dialogos_script[key_entity]
	var the_limit_repeat = the_dialogue_entity['repeat']
	var the_loop_flag = the_dialogue_entity['loop']
	var the_mode = the_dialogue_entity['mode']
	print("the_limit_repeat ",the_limit_repeat)
	print("the_loop_flag ",the_loop_flag)
	print("the_mode ",the_mode)
	
	#---datos---
	var the_sequences = the_dialogue_entity['dialogue_sequences']
	var total_sequences = the_sequences.size()
	print("total_sequences ",total_sequences)
	if the_mode == 'random':
		print("MODO RANDOM")
		print("Obtener cualquier secuencia al azar. Cantidad de secuencias: ",total_sequences)
		current_sequence = randi() % total_sequences
		print("Secuencia al azar: ",current_sequence)
	#---
	
	var is_repetition = false
	var the_sequence
	
	# Si no llegamos al final de las secuencias
	if current_sequence < total_sequences:
		print("Buscamos la secuencia y movemos el contador para la próxima consulta")
		the_sequence = the_sequences[current_sequence]
		current_sequence += 1
		dialogues_performed[key_entity] = {
			'repeat': current_repeat,
			'current_sequence': current_sequence,
			'saynomore': saynomore
		}
		return the_sequence
	else:
		print("Se llegó al límite de secuencias.")
		print("Reiniciamos el contador y marcamos is_repetition como true")
		current_sequence = 0
		current_repeat += 1
		is_repetition = true
		
	# Si no podemos repetir llegamos al límite y devolvemos un diccionario vacío
	if  is_repetition and the_limit_repeat == 0:
		print("La secuencia es única, no se repite. FIN")
		the_sequence = []
		saynomore = true
	
	if is_repetition and current_repeat==the_limit_repeat:
		print("Se alcanzó el límite de repeticiones. FIN")
		the_sequence = []
		saynomore = true
		
	if not saynomore and is_repetition:
		print("El modo LOOP")
		if the_loop_flag:
			print("Modo LOOP")
			# Volvemos al inicio
			current_sequence = 0
		else:
			# La última
			current_sequence = the_sequences.size()-1

	the_sequence = the_sequences[current_sequence]
	current_sequence += 1
		
	dialogues_performed[key_entity] = {
		'repeat': current_repeat,
		'current_sequence': current_sequence,
		'saynomore': saynomore
	}
	return the_sequence
	
var is_current_dialog_started: bool = false
var is_current_dialog_finished: bool = false

signal current_dialog_finished

"""
var is_current_part_active: bool = false
var current_dialog_part_duration: float = 0.0
var current_dialog_actor: Node
var current_dialog_type: String
var current_dialog_text: String
var current_dialog_replacement: String  # Esto es TEXTO que reemplaza la cadena <%R%>
"""

# actors debe recibir un diccionario con 2 elementos que apuntan 
# a los nodos de las entidades involucradas en la secuencia de diálogo.
var player: Node
var npc: Node

var the_secuence: Array
var the_replacements: Dictionary
var the_content: String
var the_duration: float
var the_content_type: String
var the_balloon_type: String

var current_dialog_actor: String
var current_dialog_part: int
var next_dialog_part: int

var hud

func dialog_director (dialog_sequence: Array, actors: Dictionary, replacements: Dictionary) -> void:
	
	if dialog_sequence==[]:
		current_dialog_finished.emit()
		return
	
	is_current_dialog_started = false
	is_current_dialog_finished = false
	
	# Establecemos la referencia a los actores
	# Y les indicamos que están en medio de un diálogo en curso
	if actors.has('player'):
		player = actors['player']
		player.is_in_dialog = true
	if actors.has('npc'):
		npc = actors['npc']
		npc.is_in_dialog = true
		
	the_secuence = dialog_sequence
	the_replacements = replacements
	current_dialog_part = -1
	next_dialog_part = 0
	is_current_dialog_started = true
	hud = get_tree().get_current_scene().get_node("HudNivel")
	hud.show_dialog_controls()
	print("Iniciamos la secuencia de diálogo...")

func _process(_delta:float)	->void:
	
	if is_current_dialog_started==false and is_current_dialog_finished == false:
		return
	
	if is_current_dialog_started==true and is_current_dialog_finished == true:
		# El diálogo empezó y terminó. 
		# Ponemos los flags en false para no procesar y finalizarmos
		if player:
			player.is_talking = false
			player.is_in_dialog = false
			player.mute_dialog()
		if npc:
			npc.is_talking = false
			npc.is_in_dialog = false
			npc.mute_dialog()
		is_current_dialog_started = false
		is_current_dialog_finished = false
		hud = get_tree().get_current_scene().get_node("HudNivel")
		hud.hide_dialog_controls()
		current_dialog_finished.emit()
		return
	
	# En este punto damos por supuesto que el 
	# dialogo empezó y no terminó. Hay que procesar las partes.
	
	if Input.is_action_just_pressed("dialogo_saltar_parte") or GameState.touch_dialogo_saltar_parte:
		GameState.touch_dialogo_saltar_parte = false
		the_duration = 0.0

	if Input.is_action_just_pressed("dialogo_saltar_todo") or GameState.touch_dialogo_saltar_todo:
		GameState.touch_dialogo_saltar_todo = false
		print("SALTA TODO")
		#next_dialog_part = the_secuence.size()
		
	# 1 - Comprobamos si hay que avanzar o actualizar el TIMER
	if current_dialog_part == next_dialog_part:
		the_duration -= 1 * _delta
		if the_duration <= 0.0:
			# Si llegamos al final del timer avanzamos a la marca
			# a la siguiente parte.
			next_dialog_part += 1
		return
		
	# 2 - Actualizamos la parte
	current_dialog_part = next_dialog_part


	
	# 3 - Comprobamos si no llegamos al final del diálogo
	if not current_dialog_part < the_secuence.size():
		# llegamos al final. Ponemos el flag de finalizado
		is_current_dialog_finished = true
		return
		
	# 4 - obtenemos la parte
	var dialog_part = the_secuence[current_dialog_part]

	# 5 - Preparamos a los actores
	if player:
		player.is_talking = false
		player.mute_dialog()
	if npc:
		npc.is_talking = false
		npc.mute_dialog()
	
	# 6 - Obtenemos la información de la parte a ejecutar
	the_content = dialog_part['text']
		
	if dialog_part.has('duration'):
		the_duration = dialog_part['duration']
	else:
		the_duration = 2.8

	if dialog_part.has('content_type'):
		the_content_type = dialog_part['content_type']
	else:
		the_content_type = 'text'
	
	if dialog_part.has('balloon_type'):
		the_balloon_type = dialog_part['balloon_type']
	else:
		the_balloon_type = 'speak'
		
	# 7 - Reemplazamos marcas especiales en los textos por valores dinámicos.
	if not the_replacements.is_empty():
		for key in the_replacements.keys():
			var value = str(the_replacements[key])
			the_content = the_content.replace(str(key),value)

	# 8 - Hacemos que el actor ejecute el diálogo
	if dialog_part['actor'] == 'player':
		player.is_talking = true
		player.play_dialog(the_content, the_content_type, the_balloon_type)

	if dialog_part['actor'] == 'npc':
		npc.is_talking = true
		npc.play_dialog(the_content, the_content_type, the_balloon_type)
	
# END _process

func reset_dialogues_performed() -> void:
	dialogues_performed.clear()
	print("Estado de DIALOGOS reseteados")
# ------------------------------------------------------------------------------
