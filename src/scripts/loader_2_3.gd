extends Node2D

@onready var animacion = $AnimationPlayer

func _ready() -> void:
	animacion.play("transicion")
	animacion.animation_finished.connect(_on_animacion_terminada)

func _on_animacion_terminada(anim_name: String) -> void:
	if anim_name == "transicion":
		get_tree().change_scene_to_file("res://src/scenes/levels/level_1_seccion_c.tscn")
