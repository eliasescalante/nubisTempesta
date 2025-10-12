extends Node2D

@onready var hud = get_tree().get_current_scene().get_node("HudNivel")
@export var zona : String = "NIVEL 1 - ZONA A"
@export var nivel : String = "BAJOS SOÑADORES"

func _ready() -> void:
	
	var player = $Player
	if GameState.portal == 1:
		var spawn_point = $Portalb/Marker2D
		player.global_position = spawn_point.global_position
		GameState.portal = 0
	
	if hud:
		hud.actualizar_nivel_y_zona(zona, nivel )

func _process(delta: float) -> void:
	pass

func _on_portalb_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameState.portal = 2
		GameState.loader = 6
		GameState.text_loader = "THE BAR..."
		print(GameState.portal)
		get_tree().change_scene_to_file("res://src/scenes/levels/loader.tscn")
