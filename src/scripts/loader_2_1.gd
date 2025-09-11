extends Node2D

@onready var animacion = $AnimationPlayer
@onready var titulo_label = $Label  # <- ajustado al nombre real

func _ready() -> void:
	animacion.play("transicion")
	animacion.animation_finished.connect(_on_animacion_terminada)

func _on_animacion_terminada(anim_name: String) -> void:
	if anim_name == "transicion":
		get_tree().change_scene_to_file("res://src/scenes/levels/test_scene_level_01.tscn")
