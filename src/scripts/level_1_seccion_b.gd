extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = $Player
	var spawn_point = $Portal1a2/Marker2D
	if GameState.portal == 2:
		player.global_position = spawn_point.global_position
		GameState.portal = 0
		print("valor de portal ahora")
		print(GameState.portal)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_portal_1a_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameState.portal = 1
		print(GameState.portal)
		call_deferred("_change_to_loader")
		
func _change_to_loader():
	get_tree().change_scene_to_file("res://src/scenes/levels/loader_2_1.tscn")

func _on_portal_2a_3_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameState.portal = 3
		get_tree().change_scene_to_file("res://src/scenes/levels/loader_2_3.tscn")
	pass # Replace with function body.
