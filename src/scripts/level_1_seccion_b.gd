extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_portal_1a_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://src/scenes/levels/loader_2_1.tscn")
	pass # Replace with function body.


func _on_portal_2a_3_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://src/scenes/levels/loader_2_3.tscn")
	pass # Replace with function body.
