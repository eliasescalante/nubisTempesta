extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _on_portal_2_3_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameState.portal = 3
		print(GameState.portal)
		get_tree().change_scene_to_file("res://src/scenes/levels/loader_2_1.tscn")
	pass # Replace with function body.


func _on_portalb_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameState.portal = 3
		print(GameState.portal)
		get_tree().change_scene_to_file("res://src/scenes/levels/loader_1.tscn")
	pass # Replace with function body.
