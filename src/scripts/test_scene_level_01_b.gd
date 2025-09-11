extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_nivel_1()
	var player = $Player
	var spawn_point = $Portal1/Marker2D
	if GameState.portal == 1:
		player.global_position = spawn_point.global_position
		GameState.portal = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_portal_1_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameState.portal = 2
		get_tree().change_scene_to_file("res://src/scenes/levels/loader_1.tscn")
	pass # Replace with function body.
