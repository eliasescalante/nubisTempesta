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
					'actor': 'player',
					'text': 'Este dialogo se repite 3 veces',
					'duration': 0.5,
					'content_type': 'text'
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
					'content_type': 'icon', # Estilo ícono / Por defecto es 'speak'
					'balloon_type': 'thought'
				},
				{
					'actor': 'player',
					'text': 'Necesito juntar \n 5.000 créditos PLD \n o no podré continuar\n mi "investigación."',
				},
				{
					'actor': 'player',
					'text': '¡Vaya, mi PLD \n está disminuyendo rápido!.',
					'balloon_type': 'thought' # Estilo pensamiento
				},
				{
					'actor': 'player',
					'text': 'Más de lo habitual.\n Será mejor \nque me apure',
					'duration': 2.0,
					'balloon_type': 'thought' # Estilo pensamiento
				}
			]
		]
	},
	'npc-estorbo': {
		'repeat': -1, # -1 infinito
		'loop': false,
		'mode': 'sequential', # 'random'. Cualquier de las secuencias
		'dialogue_sequences': [ # secuencia de dialogos
			[ # secuencia de dialogo
				{
					'actor': 'player',
					'text': 'Necesito pasar.',
				},
				{
					'actor': 'npc',
					'text': 'mmm, quiero un \n <%OBJ%> \n me gustan mucho \n mucho..."',
				},
				{
					'actor': 'player',
					'text': '¡que molesto! \n necesito moverlo. \n Tendré que buscar \n eso que desea.',
					'duration': 3.3,
					'balloon_type': 'thought', # Estilo pensamiento
				}
			],
			[
				{
					'actor': 'npc',
					'text': '<%OBJ%>',
					'content_type': 'icon'
				},
			],
		],
	},
	'chisme-honguitos': {
		'repeat': -1, # -1 infinito
		'loop': true,
		'mode': 'sequential', # 'random'. Cualquier de las secuencias
		'dialogue_sequences': [ # secuencia de dialogos
			[ # secuencia de diálogo #1
				{
					'actor': 'npc',
					'text': 'Los hongitos \n están buenísimos.',
					'duration': 2.2,
					'content_type': 'text'
				},
				{
					'actor': 'player',
					'text': '¡Vaya, que emoción!',
					'duration': 1.7,
					'balloon_type': 'thought' # Estilo pensamiento
				},
			],
			[ # secuencia de diálogo #2
				{
					'actor': 'npc',
					'text': '¡Pero los chupachups...\n son lo más! ',
					'duration': 2.2,
					'content_type': 'text'
				},
				{
					'actor': 'player',
					'text': 'Entiendo, gracias.',
					'duration': 1.7,
				},
			],
			[ # secuencia de diálogo #3
				{
					'actor': 'npc',
					'text': 'honguito', # esto lo usamos para referencias al objeto
					'duration': 2.2,
					'content_type': 'icon'
				},
				{
					'actor': 'player',
					'text': 'Interesante obseción',
					'duration': 1.7,
					'balloon_type': 'thought' # Estilo pensamiento
				},
			],
		] # dialog_sequences
	},
	'historia-1': {
		'repeat': -1, # -1 infinito
		'loop': false,
		'mode': 'sequential', # 'random'. Cualquier de las secuencias
		'dialogue_sequences': [ # secuencia de dialogos
			[ # secuencia de dialogo 1
				{
					'actor': 'npc',
					'text': 'Necesito que consigas \n un <%OBJ%>.',
				},
				{
					'actor': 'player',
					'text': '¡Una misión!',
				},
			],
			[ # secuencia de dialogo 1
				{
					'actor': 'npc',
					'text': '¿Todavía no tenés \n el <%OBJ%> ? \n Seguí buscando.',
				},
			],
		],
	},
	'historia-1-completed': {
		'repeat': -1,
		'loop': false,
		'mode': 'sequential', # 'random'. Cualquier de las secuencias
		'dialogue_sequences': [ # secuencia de dialogos
			[ # secuencia de dialogo 1
				{
					'actor': 'npc',
					'text': 'Bien hecho. \n Ten tu Recompensa \n un pase <%REW%> \n y <%PLD%> PLD.',
				},
				{
					'actor': 'player',
					'text': '¡WOW!',
				},
				{
					'actor': 'player',
					'text': '¡Tengo que \n dedicarme a esto!',
					'duration': 3.3,
					'balloon_type': 'thought', # Estilo pensamiento
				},
			],
			[ # secuencia de dialogo 1
				{
					'actor': 'npc',
					'text': 'Ya no necesito nada. \n Buscá a otro. \n ¡Chau!',
				},
			],
		],
	}, # END historia-1-completed
	'patovica-1': {
		'repeat': -1,
		'loop': false,
		'mode': 'sequential', # 'random'. Cualquier de las secuencias
		'dialogue_sequences': [ # secuencia de dialogos
			[ # secuencia de dialogo 1
				{
					'actor': 'npc',
					'text': "Alto, necesitás \n <%OBJ%> PLD \n para pasar. \n Tomátelas",
					'duration': 3.3,
				},
				{
					'actor': 'player',
					'text': '¡Eh! ¡¿Qué rompimos?!\n Ya vuelvo.',
				},
				{
					'actor': 'player',
					'text': 'Parece muy exclusivo. \n Tengo que lograr \n entrar ahí!',
					'duration': 3.3,
					'balloon_type': 'thought', # Estilo pensamiento
				},
			],
			[ # secuencia de dialogo 2
				{
					'actor': 'npc',
					'text': '¿Te falta para \n <%OBJ%> PLD ?\n Volvé cuando \n tengas esa cantidad.',
				},
				{
					'actor': 'player',
					'text': '¡GGGRRRR!',
					'duration': 1.8,
					'balloon_type': 'thought', # Estilo pensamiento
				},
			],
		],
	}, # END patovica-1
}
