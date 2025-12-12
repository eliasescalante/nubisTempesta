extends Node

# para los touch mobiel
var touch_left := false
var touch_right := false
var touch_jump := false
var touch_dash := false
var touch_pause := false

# ------------------------------------------------------------------------------
var tutorial = true # Al comienzo del juego muestra los diálogos de tutorial.
var tutorial_player_first_move = true
# ------------------------------------------------------------------------------
# DATA PARA EL LOADER ENTRE ESCENAS
var portal #1 es al nivel inicial, 2 al nivel 2 y el 3
var loader # para cargar la escena a donde ir
var text_loader #para cargar el TITULO del loader
var text_loader_subtitulo #para los subtitulos
var image_loader_mini # para cargar la imagen mini
# ------------------------------------------------------------------------------
# DATA DEL PLAYER
var pld: int
# Slots del inventario en el HUD
var item_used: String
var item_quest: String
var item_pass: String
# Encargo/Quest activada
var quest_id: String
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
var game_over
var timer_game_over
var game_over_scene_launched
# ------------------------------------------------------------------------------

func reset_game_state():
	portal = 0 #1 es al nivel inicial, 2 al nivel 2 y el 3
	loader = 0 # para cargar la escena a donde ir
	text_loader="" #para cargar el TITULO del loader
	text_loader_subtitulo="" #para los subtitulos
	image_loader_mini="" # para cargar la imagen mini
	pld = 203
	item_used = ""
	item_quest = ""
	item_pass = ""
	quest_id = ""
	game_over = false
	timer_game_over = 3.0 # Lo que dura en pantalla ingame con Nubis muerta hasta que se dispare la cortina.
	game_over_scene_launched = false
	reset_npcs_data()
	DialogManager.reset_dialogues_performed()
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
		'target_pld_desired': npc_node.target_pld_desired, # lo que el NPC desea. Depende del type.
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

# Función para verificar si un NPC tiene quest completa.
# Devuelve TRUE si ya se completó. Esto se consulta en el INIT de cada NPC
# y si ya está completa lo desactiva.
# Devuele FALSE en el caso de que todavía no esté completa o no se haya identificado el NPC.
# Se podría renombrar como 'npc_has_quest_completed' para hacerla más semánticamente correcta
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

func clear_respawn_points() ->void:
	respawn_point = Vector2.ZERO

func set_respawn_point(player_respawn_point: Node) -> void:
	print("Registra punto de regeneración ", player_respawn_point)
	respawn_point = player_respawn_point.get_global_position()

func get_respawn_point(player: Node, player_respawn_points: Node2D) -> Vector2:
	print("Ultimo punto de regeneración ",respawn_point)
	# Si no hay registrado un punto de retorno buscamos el más cercano.
	if not respawn_point or respawn_point == Vector2.ZERO:
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
