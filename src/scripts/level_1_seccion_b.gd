extends Node2D

@onready var hud = get_tree().get_current_scene().get_node("HudNivel")
@export var zona : String = "NIVEL 1 - ZONA B"
@export var nivel : String = "AFUERA XD "


func _ready() -> void:
	
	var player = $Player
	if GameState.portal == 3:
		var spawn_point = $Portal_bar/Marker2D
		player.global_position = spawn_point.global_position
		GameState.portal = 0
	elif GameState.portal == 1:
		var spawn_point = $Portal_bar_2/Marker2D
		player.global_position = spawn_point.global_position
		GameState.portal = 0
	elif GameState.portal == 2:
		var spawn_point = $Portal_bar_3/Marker2D
		player.global_position = spawn_point.global_position
		GameState.portal = 0
	elif GameState.portal == 4:
		var spawn_point = $Portal_bar_4/Marker2D
		player.global_position = spawn_point.global_position
		GameState.portal = 0
	
	if hud:
		hud.actualizar_nivel_y_zona(zona, nivel )

#portal que lleva al bar 1
func _on_portalb_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameState.portal = 1
		GameState.loader = 4
		GameState.text_loader = "THE BAR..."
		print(GameState.portal)
		get_tree().change_scene_to_file("res://src/scenes/levels/loader.tscn")

#Portal que lleva al bar 2
func _on_portal_2_3_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameState.portal = 3
		GameState.loader = 1
		GameState.text_loader = "THE BAR..."
		print(GameState.portal)
		get_tree().change_scene_to_file("res://src/scenes/levels/loader.tscn")

#Portal que lleva al bar 3
func _on_portal_bar_3_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameState.portal = 1
		GameState.loader = 5
		GameState.text_loader = "THE BAR..."
		print(GameState.portal)
		get_tree().change_scene_to_file("res://src/scenes/levels/loader.tscn")

#Portal que lleva al bar 4
func _on_portal_bar_4_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameState.portal = 1
		GameState.loader = 6
		GameState.text_loader = "THE BAR..."
		print(GameState.portal)
		get_tree().change_scene_to_file("res://src/scenes/levels/loader.tscn")
