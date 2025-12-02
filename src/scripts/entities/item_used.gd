extends Node2D

signal item_collected(item_scene_path: String, position: Vector2, item_type: String, item_specimen: String)

@export var pld_bonus: int = 50
@export var respawn_time: float = 15.0
@export var item_type : String = "used" # Esto debería cambiar entre USED | BONUS

@export var item_specimen: String = "" 
# HARDCODE - esto debería ser el nombre de la escena para los NPC ESTORBO que hay que mover.

var item_specimens: Array = ["chupachups","honguito","morphball","plasmido","soul"]

func _ready() -> void:
	
	# Obtenemos el nombre de archivo de la escena
	# en el formato 'ruta/item_SPECIMEN.tscn'
	# y nos quedamos solo con la especie 
	# eliminando de la cadena la ruta y el prefijo
	# y luego eliminando la extensión.
	#
	# NOTA: OJO, esto es ARBOL_DEPENDIENTE
	
	var scene_file_name = str(get_scene_file_path())
	scene_file_name = scene_file_name.replace("res://src/scenes/entities/item_","")
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
	if body.is_in_group("player"):
		var hud = get_tree().get_root().find_child("HudNivel", true, false)
		if hud:
			hud.agregar_item($Sprite2D.texture, item_type, item_specimen)
		
		if body.has_method("sumar_pld"):
			body.sumar_pld(pld_bonus)
		
		# En lugar de borrarnos, avisamos al nivel
		emit_signal("item_collected", get_meta("scene_path"), global_position, item_type, item_specimen, respawn_time)
		queue_free()
		print("✅ Se agregó al HUD:", item_type)
