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
	'tutorial-salto': {
		'repeat': -1, # -1 infinito
		'loop': true,
		'mode': 'sequential', # 'random'. Cualquier de las secuencias
		'dialogue_sequences': [ # secuencia de dialogos
			[ # secuencia de dialogo 1
				{
					'actor': 'npc', # 'npc'
					'text': '"SALTAR" es fácil. \n Presionar la tecla \n [ESPACIO].',
					'duration': 3.8, # Por defecto cada globo dura 2.8 seg.
				},
				{
					'actor': 'player',
					'text': 'Me parecía obvio\n pero es bueno\n confirmarlo.',
				},
			], # END secuencia de dialogo 1
			[ # secuencia de dialogo 2
				{
					'actor': 'npc', # 'npc'
					'text': 'Puedes moverte \n hacia los lados\n mientras estás \n en el aire.',
					'duration': 3.8, # Por defecto cada globo dura 2.8 seg.
				},
				{
					'actor': 'player',
					'text': '¡Ah! Eso está mejor.',
				},
			], # END secuencia de dialogo 2
			[ # secuencia de dialogo 3
				{
					'actor': 'npc', # 'npc'
					'text': 'El salto consume PLD. \n Y aterrizar... \n también.',
					'duration': 3.8, # Por defecto cada globo dura 2.8 seg.
				},
				{
					'actor': 'player',
					'text': '¿Nada es gratis, no?',
				},
			], # END secuencia de dialogo 3
		] # END secuencia de dialogos
	}, # END tutorial-salto
	'tutorial-pld-1': {
		'repeat': -1, # -1 infinito
		'loop': true,
		'mode': 'sequential', # 'random'. Cualquier de las secuencias
		'dialogue_sequences': [ # secuencia de dialogos
			[ # secuencia de dialogo 1
				{
					'actor': 'npc', # 'npc'
					'text': 'Todo lo que hagas \n consume tu crédito "PLD". \n ¡Cuidalo!',
					'duration': 3.8, # Por defecto cada globo dura 2.8 seg.
				},
				{
					'actor': 'player',
					'text': 'Pfff! \nEso ya lo sé.',
				},
				{
					'actor': 'player',
					'text': '¡Ejem... \n No está mal\n recordarlo!',
					'balloon_type': 'thought' # Estilo pensamiento
				},
			], # END secuencia de dialogo 1
		] # END secuencia de dialogos
	}, # END tutorial-pld-1
	'tutorial-dash': {
		'repeat': -1, # -1 infinito
		'loop': true,
		'mode': 'sequential', # 'random'. Cualquier de las secuencias
		'dialogue_sequences': [ # secuencia de dialogos
			[ # secuencia de dialogo 1
				{
					'actor': 'npc', # 'npc'
					'text': 'Puedes hacer "DASH"\n cuando te mueves \n hacia los lados \n usando [SHIFT].',
					'duration': 3.8, # Por defecto cada globo dura 2.8 seg.
				},
				{
					'actor': 'player',
					'text': '¡Puede ser muy útil!',
				},
				{
					'actor': 'npc', # 'npc'
					'text': 'Si, mucho. Sobre\n todo cuando saltas.\n ¿Ves ese honguito?\n Intenta tomarlo.',
					'duration': 3.8, # Por defecto cada globo dura 2.8 seg.
				},
				{
					'actor': 'player',
					'text': 'Es pan comido.',
				},
			], # END secuencia de dialogo 1
			[ # secuencia de dialogo 2
				{
					'actor': 'npc', # 'npc'
					'text': 'Hacer "DASH" \n consume mucho PLD.\n No abuses.',
					'duration': 3.8, # Por defecto cada globo dura 2.8 seg.
				},
				{
					'actor': 'player',
					'text': '¡¿Y ahora me lo decís?!',
				},
			], # END secuencia de dialogo 2
		] # END secuencia de dialogos
	}, # END tutorial-dash
	'tutorial-doble-salto': {
		'repeat': -1, # -1 infinito
		'loop': true,
		'mode': 'sequential', # 'random'. Cualquier de las secuencias
		'dialogue_sequences': [ # secuencia de dialogos
			[ # secuencia de dialogo 1
				{
					'actor': 'npc', # 'npc'
					'text': 'Realiza un "DOBLE SALTO" \n presionando la tecla \n [ESPACIO] otra vez \n al saltar.',
					'duration': 3.8, # Por defecto cada globo dura 2.8 seg.
				},
				{
					'actor': 'player',
					'text': 'Gracias.',
				},
			], # END secuencia de dialogo 1
			[ # secuencia de dialogo 2
				{
					'actor': 'npc', # 'npc'
					'text': 'Intenta hacero en lo\n más elevado del primer\n salto para alcanzar\n zonas más altas.',
					'duration': 3.8, # Por defecto cada globo dura 2.8 seg.
				},
				{
					'actor': 'player',
					'text': 'Lo tendré en cuenta.',
				},
			], # END secuencia de dialogo 2
			[ # secuencia de dialogo 3
				{
					'actor': 'npc', # 'npc'
					'text': 'Mientras más alto, \n más fuerte la caida. \n El consumo de PLD \n es mayor.',
					'duration': 3.8, # Por defecto cada globo dura 2.8 seg.
				},
				{
					'actor': 'player',
					'text': '¡Vaya, tendré cuidado!',
				},
			], # END secuencia de dialogo 3
		] # END secuencia de dialogos
	}, # END tutorial-doble-salto
	'tutorial-estorbos': {
		'repeat': -1, # -1 infinito
		'loop': true,
		'mode': 'sequential', # 'random'. Cualquier de las secuencias
		'dialogue_sequences': [ # secuencia de dialogos
			[ # secuencia de dialogo 1
				{ # npc
					'actor': 'npc',
					'text': 'Los HONGUITOS \n son geniales\n'+
					'pero los CHUPACHUPS \n son mejores.',
					'duration': 3.8,
				},
				{ # player
					'actor': 'player',
					'text': 'Cada quien \n con sus gustos\n y deseos.',
				},
				{ # npc
					'actor': 'npc',
					'text': 
					'Si, pero ten cuidado.\n'+
					'Algunos seres no\n'+
					'controlan sus deseos...',
					'duration': 4.2,
				},
				{ # npc
					'actor': 'npc',
					'text': 
					'...y pueden ser \n'+
					'peligrosos cuando se \n'+
					'obsecionan con algo\n específico.',
					'duration': 3.8,
				},
				{ # player
					'actor': 'player',
					'text': 'Supongo que mientras\n no molesten o \n estorben...',
				},
				{ # npc
					'actor': 'npc', # 'npc'
					'text': 
					'¡Ese es el tema! \n'+
					'¡Se pueden obsecionar \n'+
					'con un lugar\n'+
					'y no moverse!...',
					'duration': 3.8, # Por defecto cada globo dura 2.8 seg.
				},
				{ # npc
					'actor': 'npc', # 'npc'
					'text': 
					'...a menos que \n'+
					'les ofrezcas algo \n'+
					'que deseen más.\n'+
					'Entonces...',
					'duration': 3.8,
				},
				{ # npc ...
					'actor': 'npc', # 'npc'
					'text': '...',
					'duration': 1.2,
				},
				{ # player !!!
					'actor': 'player',
					'text': '¡¿Entonces...?!',
					'duration': 2.5,
				},
				{ # npc
					'actor': 'npc', # 'npc'
					'text': 
					'¡corre!\n'+
					'se vuelven más \n'+
					'salvajes, te arrebatan\n'+
					'y drean PLD.'
					,
					'duration': 3.8, # Por defecto cada globo dura 2.8 seg.
				},
				{ # player !!!
					'actor': 'player',
					'text': '¡¿Y qué \n puedo hacer?!',
					'duration': 2.5,
				},
				{ # npc
					'actor': 'npc', # 'npc'
					'text': 
					'Esquívalos e intenta\n'+
					'pararte en el lugar\n'+
					'que los obsecionaba,\n'+
					'eso los desanima.'
					,
					'duration': 3.8, # Por defecto cada globo dura 2.8 seg.
				},
				{ # player finaliza
					'actor': 'player',
					'text': '¡Vaya rollo!\n Estaré atenta.\n Gracias por la\n'+
					'"breve" charla.',
					'duration': 3.0,
				},
				{ # npc
					'actor': 'npc', # 'npc'
					'text': 
					'Cuando gustes.\n'+
					'Cuida tu PLD,\n'+
					'ya sabes que ...',
					'duration': 2.5, # Por defecto cada globo dura 2.8 seg.
				},
				{ # npc
					'actor': 'npc', # 'npc'
					'text': 
					'...¡no querrás\n convertirte\n'+
					'en un PULSOPENITENTE!',
					'duration': 4.5, # Por defecto cada globo dura 2.8 seg.
				},
			], # END secuencia de dialogo 1
			[ # secuencia de dialogo 2
				{
					'actor': 'npc', # 'npc'
					'text': 'RECUERDA:\n'+
					'* objeto deseao\n * correr y esquivar \n'+
					'* cuidar PLD.',
					'duration': 4.2, # Por defecto cada globo dura 2.8 seg.
				}
			], # END secuencia de dialogo 2
		] # END secuencia de dialogos
	}, # END tutorial-estorbos
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
	'chisme-bar': {
		'repeat': 0,
		'loop': false,
		'mode': 'sequential', # 'random'. Cualquier de las secuencias
		'dialogue_sequences': [ # secuencia de dialogos
			[ # secuencia de diálogo #1
				{
					'actor': 'npc',
					'text': 'El BAR "BARRACUDA" \n es muy famoso\n por sus tragos\n exóticos!',
					'duration': 3.8,
					'content_type': 'text'
				},
				{
					'actor': 'player',
					'text': '¡Hey, es \n lo que necesito! \n ¡Excelente!',
					'duration': 3.2,
					'balloon_type': 'thought' # Estilo pensamiento
				},
				{
					'actor': 'npc',
					'text': '¡Pero hay un molesto\n que estorba en\n la entrada! ',
					'duration': 3.8,
					'content_type': 'text'
				},
				{
					'actor': 'player',
					'text': 'Creo que ya sé\n lo que tengo\n que hacer',
					'duration': 3.2,
				},
			], # END secuencia de diálogo #1
		] # END dialog_sequences
	}, # END chisme-bar
	'item-no-disponible': {
		'repeat': -1,
		'loop': true,
		'mode': 'sequential', # 'random'. Cualquier de las secuencias
		'dialogue_sequences': [ # secuencia de dialogos
			[ # secuencia 1
				{
					'actor': 'player',
					'text': '¿Un "<%OBJ%>?"\n No me interesa,\n no vale nada.',
					'duration': 3.7,
					'content_type': 'text',
					'balloon_type': 'thought' # Estilo pensamiento
				},
			], #END secuencia 1 
			[ # secuencia 2
				{
					'actor': 'player',
					'text': 'No lo voy a tomar.',
					'duration': 2.3,
					'content_type': 'text',
					'balloon_type': 'thought' # Estilo pensamiento
				},
			], # END secuencia 2
			[ # secuencia 3
				{
					'actor': 'player',
					'text': '¿No estás \n entendiendo, no?.',
					'duration': 2.3,
					'content_type': 'text',
					'balloon_type': 'thought' # Estilo pensamiento
				},
			], # END secuencia 3
			[ # secuencia 4
				{
					'actor': 'player',
					'text': '¡Cortala!',
					'duration': 2.3,
					'content_type': 'text',
					'balloon_type': 'thought' # Estilo pensamiento
				},
			], # END secuencia 4
		] # END dialog_sequences
	}, # END item-no-disponible
	'item-buscado': {
		'repeat': 0,
		'loop': false,
		'mode': 'sequential', # 'random'. Cualquier de las secuencias
		'dialogue_sequences': [ # secuencia de dialogos
			[ # secuencia 1
				{
					'actor': 'player',
					'text': '¡Hola perdido!\n Alquien está \n interesado en vos.',
					'duration': 3.7,
					'content_type': 'text',
					'balloon_type': 'thought' # Estilo pensamiento
				},
				{
					'actor': 'player',
					'text': 'Aunque no sé\n qué puede tener\n de valioso un\n "<%OBJ%>"',
					'duration': 3.7,
					'content_type': 'text',
					'balloon_type': 'thought' # Estilo pensamiento
				},
			], #END secuencia 1 
		] # END dialog_sequences
	}, # END item-buscado
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
	#
	# ------------------------ DIALOGOS BAR ------------------------------------
	#
	'historia-1': {
		'repeat': -1, # -1 infinito
		'loop': false,
		'mode': 'sequential', # 'random'. Cualquier de las secuencias
		'dialogue_sequences': [ # secuencia de dialogos
			[ # secuencia de dialogo 1
				{
					'actor': 'player',
					'text': 'Tengo entendido que\n ofrece un pase\n "PEPBOI"\n ¿Es así?',
				},
				{
					'actor': 'npc',
					'text': 'Si, es así.\n Pero necesito algo\n a cambio. \n Un "<%OBJ%>"s.',
				},
				{
					'actor': 'npc',
					'text': 'No tengo suficiente\n destreza para \n encontrarlo.',
				},
				{
					'actor': 'player',
					'text': 'Yo realizo encargos.\n Soy una buscadora\n profesional.',
				},
				{
					'actor': 'npc',
					'text': 'Bien, espero \n que puedas\n encontrarlo.\n Te espero.',
				},

			],
			[ # secuencia de dialogo 1
				{
					'actor': 'npc',
					'text': '¿Todavía no tenés \n el "<%OBJ%>" ? \n Seguí buscando\n y no molestes.',
				},
			],
		],
	},
	'historia-1-completed': {
		'repeat': 0,
		'loop': false,
		'mode': 'sequential', # 'random'. Cualquier de las secuencias
		'dialogue_sequences': [ # secuencia de dialogos
			[ # secuencia de dialogo 1
				{
					'actor': 'npc',
					'text': 'Bien hecho. \n Ten tu Recompensa: \n el pase "<%REW%>" \n y <%PLD%> PLD.',
				},
				{
					'actor': 'player',
					'text': '¡WOW!',
					'balloon_type': 'thought', # Estilo pensamiento
				},
				{
					'actor': 'player',
					'text': '¿Eso es todo? \n Bueno, ya conoce\n mis servicios.\n Hasta luego.',
					'duration': 3.8,
				},
				{
					'actor': 'npc',
					'text': 'Te tendré en \n cuenta.\n Hasta luego...',
					'duration': 3.8,
				},
				{
					'actor': 'player',
					'text': '¡Tengo que \n dedicarme a esto!',
					'duration': 3.8,
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
	'chisme-historia-1': {
		'repeat': -1,
		'loop': true,
		'mode': 'sequential', # 'random'. Cualquier de las secuencias
		'dialogue_sequences': [ # secuencia de dialogos
			[ # secuencia de diálogo #1
				{
					'actor': 'npc',
					'text': 'Escuché que hay \n alguien que está \n ofreciendo un \n pase "PEPBOI".',
					'duration': 3.8,
					'content_type': 'text'
				},
				{
					'actor': 'player',
					'text': '¡Hey, es \n lo que necesito! \n ¡Excelente!',
					'duration': 3.2,
					'balloon_type': 'thought' # Estilo pensamiento
				},
				{
					'actor': 'player',
					'text': '¿ah, si? ¡Mirá!\n ¿Y...\n sabés dónde\n encontrarlo?',
					'duration': 3.8,
					'content_type': 'text'
				},
				{
					'actor': 'npc',
					'text': 'Creo que está\n en la parte alta\n del BAR.',
					'duration': 3.2,
				},
			], # END secuencia de diálogo #1
		] # END dialog_sequences
	}, # END chisme-historia-1
	'chisme-salida': {
		'repeat': -1,
		'loop': true,
		'mode': 'sequential', # 'random'. Cualquier de las secuencias
		'dialogue_sequences': [ # secuencia de dialogos
			[ # secuencia de diálogo #1
				{
					'actor': 'npc',
					'text': 'El BAR "BARRACUDA" \n está muy bien,\n ¡pero hay lugares\n mejores!',
					'duration': 3.8,
				},
				{
					'actor': 'player',
					'text': '¡Que interesante! \n ¿Y sabes como\n llegar a ellos?',
					'duration': 3.2,
				},
				{
					'actor': 'npc',
					'text': '¡Si, pero hay que\n tener un pase\n para ingresar a\n otras zonas.',
					'duration': 3.8,
				},
				{
					'actor': 'player',
					'text': 'Creo que ya sé\n lo que tengo\n que hacer',
					'duration': 3.2,
				},
			], # END secuencia de diálogo #1
		] # END dialog_sequences
	}, # END chisme-salida
	'patovica-2-pass': {
		'repeat': -1,
		'loop': true,
		'mode': 'sequential', # 'random'. Cualquier de las secuencias
		'dialogue_sequences': [ # secuencia de dialogos
			[ # secuencia de dialogo 1
				{
					'actor': 'npc',
					'text': '¡Alto! Para acceder \n necesitás el pase \n "<%OBJ%>". \n Suerte con eso, jaja.',
					'duration': 4.3,
				},
				{
					'actor': 'player',
					'text': 'Ya vas a ver, \n vuelvo y te paso \n el pase por la cara.',
					'duration': 4.3,
				},
				{
					'actor': 'npc',
					'text': 'Jajaja, quisiera verlo, \n insecto. A volar \n de aquí',
					'duration': 4.3,
				},
			],
			[ # secuencia de dialogo 2
				{
					'actor': 'npc',
					'text': 'Si no tenés el pase \n <%OBJ%>, \n seguí buscando... \n insecto, jajaja.',
					'duration': 4.3,
				},
				{
					'actor': 'player',
					'text': '¡GGGRRRR!',
					'duration': 1.8,
					'balloon_type': 'thought', # Estilo pensamiento
				},
			], # END seciencia 2
			[ # secuencia de dialogo 3
				{
					'actor': 'npc',
					'text': '<%OBJ%>',
					'duration': 2.2,
					'content_type': 'icon'
				},
			],
		],
	}, # END patovica-2-pass
	'patovica-2-pass-completed': {
		'repeat': 0,
		'loop': false,
		'mode': 'sequential', # 'random'. Cualquier de las secuencias
		'dialogue_sequences': [ # secuencia de dialogos
			[ # secuencia de dialogo 1
				{
					'actor': 'npc',
					'text': "¡Alto! \n ¡¿No aprendés, no?! \n Necesitás ...",
				},
				{
					'actor': 'player',
					'text': '¡Silencio!\n ¡Acá tenés \n el pase, gil! \n ¿Te cabió?',
					'duration': 3.3,
				},
				{
					'actor': 'npc',
					'text': '¡Oh, bien! Eehh... \n Puede pasar usted... \n (GGRRRR)',
					'duration': 3.3,
				},
			],
		],
	}, # END patovica-2-pass-completed
}
