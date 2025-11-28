extends Node

var portal = 0 #1 es al nivel inicial, 2 al nivel 2 y el 3
var loader = 0 # para cargar la escena a donde ir
var text_loader #para cargar el TITULO del loader
var text_loader_subtitulo #para los subtitulos
var image_loader_mini # para cargar la imagen mini

# ------------------------------------------------------------------------------

# PERSISTENCIA PARA NPCS

# Diccionario para almacenar el estado de todos los NPCs
var npcs_data := {}
# Diccionario para tracking de NPCs ya registrados por escena
var _registered_scenes := {}

func register_npcs(npc_parent_node: Node, scene_name: String) -> void:
	# Si ya registramos NPCs de esta escena, no sobrescribir
	if _registered_scenes.has(scene_name):
		print("NPCs de la escena '%s' ya fueron registrados anteriormente" % scene_name)
		return
	
	# Marcar esta escena como registrada
	_registered_scenes[scene_name] = true
	
	# Recorrer todos los hijos del nodo NPCs
	for npc in npc_parent_node.get_children():
		if npc is CharacterBody2D:
			var npc_name = npc.name
			
			# Solo inicializar si el NPC no existe en los datos
			if not npcs_data.has(npc_name):
				npcs_data[npc_name] = {
					'quest': false,
					'tipo': npc.TYPE,
					'target_desired': npc.target_desired,
					'estado': 'idle'  # o el estado inicial que uses
				}

				print("NPC registrado: ", npc_name)
			else:
				print("NPC ya existe, manteniendo estado: ", npc_name)

# Función para actualizar el estado de un NPC específico
func update_npc_state(npc_name: String, property: String, value) -> void:
	if npcs_data.has(npc_name):
		if npcs_data[npc_name].has(property):
			npcs_data[npc_name][property] = value
			print("Actualizado NPC %s: %s = %s" % [npc_name, property, str(value)])
		else:
			push_warning("Propiedad '%s' no existe para NPC %s" % [property, npc_name])
	else:
		push_warning("NPC %s no encontrado en GameState" % npc_name)

# Función para obtener datos de un NPC
func get_npc_data(npc_name: String) -> Dictionary:
	return npcs_data.get(npc_name, {})

# Función para resetear todos los datos (útil para nuevo juego)
func reset_npcs_data() -> void:
	npcs_data.clear()
	_registered_scenes.clear()
	print("Datos de NPCs reseteados")

# Función para verificar si un NPC tiene quest
func has_quest(npc_name: String) -> bool:
	if npcs_data.has(npc_name):
		return npcs_data[npc_name].get('quest', false)
	return false

# Función para obtener el estado actual de un NPC
func get_npc_state(npc_name: String) -> String:
	if npcs_data.has(npc_name):
		return npcs_data[npc_name].get('estado', '')
	return ""
