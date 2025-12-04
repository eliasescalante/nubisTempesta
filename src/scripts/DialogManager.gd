extends Node

# La BASE DE DATOS con todos los dialogos
# ESTRUCTURA
# Diccionario_1 > Diccionario_2 > Array_1 > Array_2 > Diccionario_3

# El diccionario_1 contiene todos los dialogos del juego.
# Cada key sirve para identificar la entidad que lo usa
# cuando el Player entra en el area de diálogo
#
# La key contiene un diccionario_2 con los atributos para
# ese encuentro de diálogo.
# 'repeat': cuantas veces se puede repetir las secuencias de diálogos
# 'loop': indica que al llegar a la última secuencia se reinicia o queda en último elemento.
# 'mode':  'secuence' en el orden. 'random' al azar.
# 'dialogue_sequences': contiene un Array_1 con las Secuencias de Diálogos (varios diálogos para diferentes encuentros).
# Cada Secuencia de Diálogos contiene un Array_2 con la Secuencia de Dialogo para un encuentro particular
# Secuencia de Dialogo particular que contiene en cada elemento un Diccionario_3 con
# los atributos de cada dialogo visualizado.

# NOTAS:
# 'repeat': -1 and 'loop' : false -> Repite de manera infinita la última secuencia
# 'repeat': -1 and 'loop' : true -> Repite de manera infinita todas las secuencias
# 'repeat': 0 and 'loop' : true -> No repite, con lo que loop queda anulado.

var dialogos_script = {
	'test_dialog': {
		'repeat': 3, # -1 infinito
		'loop': false,
		'mode': 'sequential', # 'random'. Cualquier de las secuencias
		'dialogue_sequences': [ # secuencia de dialogos
			[
				{
					'actor': 'player', # 'npc'
					'text': 'Este dialogo se repite 3 veces', # si 'type' es 'icon' esto hace referencia a un sprite
					'duration': 0.5, # Por defecto cada globo dura 2.8 seg.
					'type': 'icon' # Estilo ícono / Por defecto es 'speak'
				}
			]
		] # dialog_sequences
	},
	'tutorial_1': {
		'repeat': 0, # -1 infinito
		'loop': false,
		'mode': 'sequential', # 'random'. Cualquier de las secuencias
		'dialogue_sequences': [ # secuencia de dialogos
			[ # secuencia de dialogo
				{
					'actor': 'player', # 'npc'
					'text': 'honguito', # si 'type' es 'icon' esto hace referencia a un sprite
					'duration': 0.5, # Por defecto cada globo dura 2.8 seg.
					'type': 'icon' # Estilo ícono / Por defecto es 'speak'
				},
				{
					'actor': 'player',
					'text': 'Necesito juntar \n 5.000 créditos PLD \n o no podré continuar\n mi "investigación."',
					'type': 'speak' # Estilo hablado
				},
				{
					'actor': 'player',
					'text': '¡Vaya, mi PLD \n está disminuyendo rápido!.',
					'type': 'thought' # Estilo pensamiento
				},
				{
					'actor': 'player',
					'text': 'Más de lo habitual.\n Será mejor \nque me apure',
					'duration': 2.0,
					'type': 'thought' # Estilo pensamiento
				}
			]
		]
	}
}

# Aquí vamos guardando los Diálogos ejecutados
# Para controlar la repetición de los mismos
var dialogues_performed = {}

func get_dialog(key_entity:String) -> Array:
	
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
	
	
	#---datos---
	var the_sequences = the_dialogue_entity['dialogue_sequences']
	var total_sequences = the_sequences.size()
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
		print("Buscamos en la secuencia siguiente actualizada")
		the_sequence = the_sequences[current_sequence]
		current_sequence += 1
		dialogues_performed[key_entity] = {
			'repeat': current_repeat,
			'current_sequence': current_sequence,
			'saynomore': saynomore
		}
		return the_sequence
	else:
		current_sequence = 0
		current_repeat += 1
		is_repetition = true
		
	# Si no podemos repetir llegamos al límite y devolvemos un diccionario vacío
	if  is_repetition and (the_limit_repeat == 0 or current_repeat==the_limit_repeat) :
		print("No se puede repetir más. FIN")
		the_sequence = []
		saynomore = true
	# Hay que comprobar si podemos repetir dentro del limite
	else:
		if is_repetition and ( current_repeat <= the_limit_repeat or the_limit_repeat == -1 ):
			print("Se puede repetir")
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
	

# ------------------------------------------------------------------------------
"""
ESTA FUNCION DEVUEVE TODO EN SECUENCIA PERO NO ES LO NECESARIO EN ESTE MOMENTO.
POR AHORA LO QUE SE NECESITA ES PASARLE A DIALOG_DIRECTOR (el orquestador de diálogo)
LA SECUENCIA DE UN DIALOGO, NO LAS PARTES

func get_dialog(key_entity:String) -> Dictionary:
	
	var current_repeat
	var current_sequence
	var current_part
	var saynomore
	
	if not dialogues_performed.has(key_entity):
		print ("Registrar ejecución de diálogo por entidad ",key_entity)
		
		dialogues_performed[key_entity] = {
			'repeat': 0,
			'current_sequence': 0,
			'current_part': 0,
			'saynomore': 0,
		}
		
	current_repeat = dialogues_performed[key_entity]['repeat']
	current_sequence = dialogues_performed[key_entity]['current_sequence']
	current_part = dialogues_performed[key_entity]['current_part']
	saynomore = dialogues_performed[key_entity]['saynomore']
	
	print('current_repeat ',current_repeat)
	print('current_sequence ',current_sequence)
	print('current_part ',current_part)
	print('saynomore ',saynomore)
	
	if saynomore==1:
		print("SAY NO MORE!")
		return {}
	
	#---atributos---
	var the_dialogue_entity = dialogos_script[key_entity]
	var the_limit_repeat = the_dialogue_entity['repeat']
	var the_loop_flag = the_dialogue_entity['loop']
	var the_mode = the_dialogue_entity['mode']
	
	if the_mode == 'random':
		print("MODO RANDOM")
		current_sequence = randi() % the_dialogue_entity['dialogue_sequences'].size()
		print("Secuencia al azar: ",current_sequence)
	#---datos---
	var the_sequences = the_dialogue_entity['dialogue_sequences']
	#---
	var the_part = {}
	var is_repetition = false
	
	# Si todavia no superamos la cantida de partes de la secuencia actual
	if current_part < the_sequences[current_sequence].size():
		print("Extraemos de la secuencia actual la parte actual")
		the_part = the_sequences[current_sequence][current_part]
		current_part += 1
		dialogues_performed[key_entity] = {
		'repeat': current_repeat,
		'current_sequence': current_sequence,
		'current_part': current_part,
		'saynomore': 0,
		}
		return the_part
	else:
		print("Solicitamos más partes pero no hay")
		print("Pasamos a la siguiente secuencia")
		# Incrementamos a la siguiente secuencia
		current_part = 0
		current_sequence += 1
	
	# Si no llegamos al final de las secuencias
	if current_sequence < the_sequences.size():
		print("Buscamos en la secuencia siguiente actualizada")
		the_part = the_sequences[current_sequence][current_part]
		current_part += 1
		dialogues_performed[key_entity] = {
		'repeat': current_repeat,
		'current_sequence': current_sequence,
		'current_part': current_part,
		'saynomore': 0,
		}
		return the_part
	else:
		current_part = 0
		current_sequence = 0
		current_repeat += 1
		is_repetition = true
		
	# Si no podemos repetir llegamos al límite y devolvemos un diccionario vacío
	if  is_repetition and the_limit_repeat == 0:
		print("No se puede repetir más. FIN")
		the_part = {}
		saynomore = 1
	# Hay que comprobar si podemos repetir dentro del limite
	elif  is_repetition and ( current_repeat <= the_limit_repeat or the_limit_repeat == -1 ):
		print("Se puede repetir")
		current_part = 0
		if the_loop_flag:
			print("Modo LOOP")
			current_sequence = 0
		else:
			current_sequence = the_sequences.size()-1
		the_part = the_sequences[current_sequence][current_part]
		current_part += 1
		
	dialogues_performed[key_entity] = {
		'repeat': current_repeat,
		'current_sequence': current_sequence,
		'current_part': current_part,
		'saynomore': saynomore
	}
	return the_part
	
"""
