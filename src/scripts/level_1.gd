extends Node2D

@onready var collectables = $Parallax2D_medio/Collectables
@onready var hud = get_tree().get_current_scene().get_node("HudNivel")
@export var zona : String = "NIVEL 1 - ZONA A"
@export var nivel : String = "BAJOS PILARES"
@export var respawn_time: float = 1.0 # segundos para reaparecer

@onready var spawn_point_0: Marker2D = %Portal0/Marker2D
@onready var spawn_point_1: Marker2D = %Portal1/Marker2D

func _ready() -> void:
	AudioManager.play_nivel_1()
	var player = %Player
	var spawn_point = spawn_point_0
	

	# Conectar señales de todos los ítems iniciales
	for item in collectables.get_children():
		if item.has_signal("item_collected"):
			item.connect("item_collected", Callable(self, "_on_item_collected"))
	
	if GameState.portal == 1:
		spawn_point = spawn_point_1
		player.global_position = spawn_point.global_position
		GameState.portal = 0
		print("valor de portal ahora")
		print(GameState.portal)
		
	if hud:
		hud.actualizar_nivel_y_zona(zona, nivel )

func _process(delta: float) -> void:
	pass

func _on_portal_1_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameState.portal = 2
		GameState.loader = 1
		GameState.text_loader = "NIVEL 1 - ZONA B"
		GameState.text_loader_subtitulo = "BAR 'BARRACUDA'"
		GameState.image_loader_mini = "nivel_1_zona_b"
		print(GameState.portal)
		call_deferred("_change_to_loader")

func _change_to_loader():
	get_tree().change_scene_to_file("res://src/scenes/levels/loader.tscn")

func _on_item_collected(item_scene_path: String, pos: Vector2) -> void:
	print("🌀 Item recogido. Se respawneará en:", pos)
	await get_tree().create_timer(respawn_time).timeout
	
	# Instanciar de nuevo el ítem desde su escena original
	var scene = load(item_scene_path)
	if scene:
		var new_item = scene.instantiate()
		new_item.global_position = pos
		
		# reconectar su señal
		if new_item.has_signal("item_collected"):
			new_item.connect("item_collected", Callable(self, "_on_item_collected"))
		
		collectables.add_child(new_item)
		print("🍄 Item respawneado:", item_scene_path)
