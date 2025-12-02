extends Node

# ------------------------------------------------------------------------------
var tutorial = true

# DATA PARA EL LOADER ENTRE ESCENAS
var portal = 0 #1 es al nivel inicial, 2 al nivel 2 y el 3
var loader = 0 # para cargar la escena a donde ir
var text_loader #para cargar el TITULO del loader
var text_loader_subtitulo #para los subtitulos
var image_loader_mini # para cargar la imagen mini
var pld = 203
# ------------------------------------------------------------------------------

# PERSISTENCIA PARA NPCS

# Diccionario para almacenar el estado de todos los NPCs
# npcs_data[<npc_node_id>]
var npcs_data := {}

# crea un ID basado en "levelName_npcNodeName"
# Esto es importante. Antes se intento con npc_node.get_instance_id() pero el
# numero de ID que generaba cambiar cuando se recargaba la escena pasando de una zona a otra.
func get_npc_id (npc_node: Node) -> String:
	return get_current_level_name()+"_"+npc_node.name
	
# para saber en que nivel estamos 
# IMPORTANTE: que los nodos raiz de cada nivel tenga name unico y esté en el grupo 'levels'
func get_current_level_name () -> String:
	var level = get_tree().get_first_node_in_group("levels") 
	return level.name

func register_npc(npc_node: Node) -> void:
	# Si ya registramos NPCs de esta escena, no sobrescribir
	var npc_id = get_npc_id(npc_node)
	
	if npcs_data.has(npc_id):
		print("NPC ID %s de la escena ya fue registrado previamente" % npc_id)
	
	npcs_data[npc_id] = {
		'quest': false, # false: quest pendiente | true: quest complete
		'type': npc_node.type, # estorbo | chisme | patovica | historia
		'target_desired': npc_node.target_desired, # lo que el NPC desea. Depende del type.
		'dialog_number': npc_node.dialog_number, # cuenta el avance en los encuentros de dialogo entre el NPC y PLAYER
		'state': 'NpcInit' # Estado inicial para la StateMachine
	}

	print("NPC registrado: ", npc_id)

# Función para actualizar el estado de un NPC específico
func update_npc_property(npc_node: Node, property: String, value) -> void:
	var npc_id = get_npc_id(npc_node)
	if npcs_data.has(npc_id):
		if npcs_data[npc_id].has(property):
			npcs_data[npc_id][property] = value
			print("Actualizado NPC %s: %s = %s" % [npc_id, property, str(value)])
		else:
			push_warning("Propiedad '%s' no existe para NPC %s" % [property, npc_id])
	else:
		push_warning("NPC %s no encontrado en GameState" % get_npc_id(npc_node) )

func get_npc_property(npc_node: Node, property: String) -> Variant:
	var npc_id = get_npc_id(npc_node)
	return npcs_data[npc_id].get(property, null)
	
# Función para obtener datos de un NPC
func get_npc_data(npc_node: Node) -> Dictionary:
	var npc_id = get_npc_id(npc_node)
	return npcs_data.get(npc_id, {})

# Función para resetear todos los datos para iniciar nuevo juego en la misma sesión
func reset_npcs_data() -> void:
	npcs_data.clear()
	print("Datos de NPCs reseteados")

# Función para verificar si un NPC tiene quest
func npc_has_quest(npc_node: Node) -> bool:
	var npc_id = get_npc_id(npc_node)
	if npcs_data.has(npc_id):
		return npcs_data[npc_id].get('quest', false)
	return false

# Función para obtener el estado actual de un NPC
func get_npc_state(npc_node: Node) -> String:
	var npc_id = get_npc_id(npc_node)
	if npcs_data.has(npc_id):
		return npcs_data[npc_id].get('state', '')
	return "null"

#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
var respawn_point: Vector2

func set_respawn_point(player_respawn_point: Node) -> void:
	print("Registra punto de regeneración ", player_respawn_point)
	respawn_point = player_respawn_point.get_global_position()

func get_respawn_point(player: Node, player_respawn_points: Node2D) -> Vector2:
	print("Ultimo punto de regeneración ",respawn_point)
	# Si no hay registrado un punto de retorno buscamos el más cercano.
	if not respawn_point:
		var lowest_distance = INF
		var distance_tmp 
		for respawn_point_child in  player_respawn_points.get_children():
			print("respawn_point_child ",respawn_point_child)
			distance_tmp = respawn_point_child.global_position.distance_squared_to(player.global_position)
			print("distance_tmp ",distance_tmp)
			if distance_tmp < lowest_distance:
				print("Este punto es más cercano que el anterior.")
				lowest_distance = distance_tmp
				respawn_point = respawn_point_child.get_global_position()
	return respawn_point
