extends Node

# Clase 17/11/2025 
# https://www.youtube.com/watch?v=YG-ZfOKJ4ZY
# min 1:06:29

@export var initial_state: StateNPCs

# Estado actualmente activo
var current_state: StateNPCs

# Diccionario de estados disponibles por clave
var states: Dictionary = {}

# Setup
# Registra los estados hijos y conectamos la señal de cada uno.
func _ready() -> void:
	for _child in get_children():
		if _child is StateNPCs:
			# Guardamos el estado en el array.
			states[_child.name] = _child
			# Conectamos su señal de transición a nuestro manejador genérico.
			_child.Transitioned.connect(on_child_transition)
	
	# Inicializo el estado activo inicial
	if initial_state:
		print("initial_state ",initial_state)
		current_state = initial_state
		current_state.enter()

# Llamado cada frame: delegar update al estado actual
func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

# Llamado cada frame de física: delegar al _physics_process al estado actual
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

# Ver el tema de si se tiene más estados una forma de pasar un estado previo
# o mapa de paso entre estados

# Manejador central de solicitudews de transición emitidas por los estados
# Ej: on_child_transition(<state_que_emite>, <nombre_estado_target>):
func on_child_transition(state, new_state_name):
	# Solo atender si viene del estado activo
	if state != current_state:
		return
	
	# Busco el estado destino en el diccionario
	var new_state = states.get(new_state_name)
	# Si no existe, no continuo
	if !new_state:
		return
	
	# Salgo del estado actual
	if current_state:
		current_state.exit()
	
	# Cambiar referencia y ejecutamos enter() del nuevo estado 
	new_state.enter()
	current_state = new_state

# Machete \
# La StateMachine es generica, no contiene logica de juegos
# (player, detecciones, etc)
# solo gestiona transiciones.

# Hay que asegurarse que las claves del diccionatio (States)
# coincidan con los nombres que emitimos en Transitioned

# Ojo a los llamados que las transiciones porque pueden generar
# enrutados incorrectos (arbol dependiente)
