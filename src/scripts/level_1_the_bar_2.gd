extends Node2D

@onready var hud = get_tree().get_current_scene().get_node("HudNivel")
@export var zona : String = "NIVEL 1 - ZONA A"
@export var nivel : String = "BAJOS SOÑADORES"

func _ready() -> void:
	var player = $Player
	if GameState.portal == 1:
		var spawn_point = $Portal2_3/Marker2D
		player.global_position = spawn_point.global_position
		GameState.portal = 0
		print("valor de portal ahora")
		print(GameState.portal)
	elif GameState.portal == 2:
		var spawn_point = $Portalc/Marker2D
		player.global_position = spawn_point.global_position
		GameState.portal = 0
		print("valor de portal ahora")
		print(GameState.portal)
	
	if hud:
		hud.actualizar_nivel_y_zona(zona, nivel )

func _process(delta: float) -> void:
	pass

func _on_portal_2_3_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameState.portal = 1
		GameState.loader = 3
		GameState.text_loader = "OUTSIDE..."
		print(GameState.portal)
		get_tree().change_scene_to_file("res://src/scenes/levels/loader.tscn")

func _on_portalc_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameState.portal = 1
		GameState.loader = 6
		GameState.text_loader = "OUTSIDE..."
		print(GameState.portal)
		get_tree().change_scene_to_file("res://src/scenes/levels/loader.tscn")
