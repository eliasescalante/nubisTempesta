extends Node2D

# ITEM HISTORIA
# Se tienen que habilitar su recolección cuando el NPC HISTORIA
# otorga la QUEST al PLAYER
# Para eso hay que 
signal item_collected(item_scene_path: String, position: Vector2, item_type: String, item_specimen: String)

@export var pld_bonus: int = 16666
@export var respawn_time: float = 10
@export var item_type : String = "quest"
@export var item_specimen: String = "comcubo" 

@export var quest_id: String
# Este valor hay que asociarlo al del NPC-Historia correspondiente
# al dialogo de historia del NPC
# y se verifica en el GameState para comprobar su habilitación

# Esto es para tener 
var item_specimens: Array = ["comcubo"]

@onready var player: CharacterBody2D

func _ready() -> void:
	
	# Referenciamos al player
	player = get_tree().get_first_node_in_group("player")
	
	# Obtenemos el nombre de archivo de la escena
	# en el formato 'ruta/item_SPECIMEN.tscn'
	# y nos quedamos solo con la especie 
	# eliminando de la cadena la ruta y el prefijo
	# y luego eliminando la extensión.
	#
	# NOTA: OJO, esto es ARBOL_DEPENDIENTE
	
	var scene_file_name = str(get_scene_file_path())
	scene_file_name = scene_file_name.replace("res://src/scenes/entities/item_historia_","")
	scene_file_name = scene_file_name.replace(".tscn","")

	# Comprobamos que el nombre exista en el array de especies
	if item_specimens.has(scene_file_name):
		item_specimen = scene_file_name
	else:
		item_specimen = "desconocido"
	
	# print ("ITEM: "+item_specimen)
		
	if not get_scene_file_path().is_empty():
		set_meta("scene_path", get_scene_file_path())


func _on_area_2d_body_entered(body: Node) -> void:
	
	if not body.is_in_group("player"):
		return
	
	# Aquí hay que VERIFICAR si se debe recolectar o no
	# según se haya habilitado o no la quest para el player
	# en el caso de no estar habilitado dispara un diálogo.
	var the_dialog_sequence
	if quest_id != GameState.quest_id:
		the_dialog_sequence = DialogManager.get_dialog_sequence('item-no-disponible')
		print("Invocamos al método DIALOG_DIRECTOR")
		DialogManager.dialog_director(
			the_dialog_sequence,
			{ # 'actors'
				'player': player,
				#'npc': npc
			},
			{ # 'replacements'
				'<%OBJ%>': item_specimen
			}
		)
		return

	the_dialog_sequence = DialogManager.get_dialog_sequence('item-buscado')
	print("Invocamos al método DIALOG_DIRECTOR")
	DialogManager.dialog_director(
		the_dialog_sequence,
		{ # 'actors'
			'player': player,
			#'npc': npc
		},
		{ # 'replacements'
			'<%OBJ%>': item_specimen
		}
	)
	DialogManager.current_dialog_finished.connect(item_taken)
	
func item_taken():
	DialogManager.current_dialog_finished.disconnect(item_taken)
	
	var hud = get_tree().get_root().find_child("HudNivel", true, false)
	if hud:
		hud.agregar_item($Sprite2D.texture, item_type, item_specimen) 
		print("✅ Se agregó al HUD:", item_type)

	# El ITEM HISTORIA NO SUMA PUNTOS DE MANERA INMEDIATA
	##if body.has_method("sumar_pld"):
	#	body.sumar_pld(pld_bonus)
	
	# En lugar de borrarnos, avisamos al nivel
	# Tampoco respawnea (por ahora)
	emit_signal("item_collected", get_meta("scene_path"), global_position, item_type, item_specimen, respawn_time)
	# Liberamos
	queue_free()
		
