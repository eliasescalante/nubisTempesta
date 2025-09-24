extends Node2D

@onready var animacion = $AnimationPlayer
@onready var titulo_label = $Label

func _ready() -> void:
	animacion.play("transicion")
	animacion.animation_finished.connect(_on_animacion_terminada)
	titulo_label.text = GameState.text_loader

func _on_animacion_terminada(anim_name: String) -> void:
	if anim_name == "transicion":
		if GameState.loader == 1:
			get_tree().change_scene_to_file("res://src/scenes/levels/level_1_the_bar_1.tscn")
		elif GameState.loader == 2:
			get_tree().change_scene_to_file("res://src/scenes/levels/level_1.tscn")
		elif GameState.loader == 3:
			get_tree().change_scene_to_file("res://src/scenes/levels/level_1_seccion_b.tscn")
		elif GameState.loader == 4:
			get_tree().change_scene_to_file("res://src/scenes/levels/level_1_the_bar_2.tscn")
		elif GameState.loader == 5:
			get_tree().change_scene_to_file("res://src/scenes/levels/level_1_the_bar_3.tscn")
		elif GameState.loader == 6:
			get_tree().change_scene_to_file("res://src/scenes/levels/level_1_the_bar_4.tscn")
