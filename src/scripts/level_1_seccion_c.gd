extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = $Player
	if GameState.portal == 1:
		var spawn_point = $Portalb/Marker2D
		player.global_position = spawn_point.global_position
		GameState.portal = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_portalb_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameState.portal = 2
		GameState.loader = 6
		GameState.text_loader = "THE BAR..."
		print(GameState.portal)
		get_tree().change_scene_to_file("res://src/scenes/levels/loader.tscn")
