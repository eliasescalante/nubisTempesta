extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = $Player
	if GameState.portal == 1:
		var spawn_point = $Portal2_3/Marker2D
		player.global_position = spawn_point.global_position
		GameState.portal = 0
		print("valor de portal ahora")
		print(GameState.portal)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_portal_2_3_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
