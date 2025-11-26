extends Area2D

@export var destino_escena : String
@export var destino_portal : String
@export var titulo_destino : String = ""

func _ready() -> void:
	# Conexión de señal usando Callable
	if not is_connected("body_entered", Callable(self, "_on_body_entered")):
		connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		GameState.next_scene = destino_escena
		GameState.last_portal = destino_portal
		GameState.next_title = titulo_destino
		get_tree().change_scene_to_file("res://src/scenes/loader.tscn")
