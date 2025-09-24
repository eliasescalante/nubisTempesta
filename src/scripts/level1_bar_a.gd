extends Node2D

func _ready() -> void:
	var player = $Player
	if GameState.portal == 2:
		var spawn_point = $Portal_1/Marker2D
		player.global_position = spawn_point.global_position
		GameState.portal = 0
		print("valor de portal ahora")
		print(GameState.portal)
	elif GameState.portal == 3:
		var spawn_point = $Portal2a3/Marker2D
		player.global_position = spawn_point.global_position
		GameState.portal = 0
		print("valor de portal ahora")
		print(GameState.portal)

func _process(delta: float) -> void:
	pass

func _on_portal_1a_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameState.portal = 1
		GameState.loader = 2
		GameState.text_loader = "OUTSIDE..."
		print(GameState.portal)
		get_tree().change_scene_to_file("res://src/scenes/levels/loader.tscn")

func _on_portal_2a_3_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameState.portal = 3
		GameState.loader = 3
		GameState.text_loader = "OUTSIDE..."
		print(GameState.portal)
		get_tree().change_scene_to_file("res://src/scenes/levels/loader.tscn")
