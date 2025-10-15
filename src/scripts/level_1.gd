extends Node2D

@onready var hud = get_tree().get_current_scene().get_node("HudNivel")
@export var zona : String = "NIVEL 1 - ZONA A"
@export var nivel : String = "BAJOS SOÑADORES"

func _ready() -> void:
	AudioManager.play_nivel_1()
	var player = %Player
	var spawn_point = %Portal1/Marker2D
	
	if GameState.portal == 1:
		player.global_position = spawn_point.global_position
		GameState.portal = 0
		print("valor de portal ahora")
		print(GameState.portal)
		
	if hud:
		hud.actualizar_nivel_y_zona(zona, nivel )

func _process(delta: float) -> void:
	pass

func _on_portal_1_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameState.portal = 2
		GameState.loader = 1
		GameState.text_loader = "THE BAR..."
		print(GameState.portal)
		call_deferred("_change_to_loader")

func _change_to_loader():
	get_tree().change_scene_to_file("res://src/scenes/levels/loader.tscn")
