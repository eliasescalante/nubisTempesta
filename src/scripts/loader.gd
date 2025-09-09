extends Node2D

@onready var animacion = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animacion.play("transicion")
	animacion.animation_finished.connect(_on_animacion_terminada)
		
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_animacion_terminada(anim_name: String) -> void:
	if anim_name == "transicion":
		get_tree().change_scene_to_file("res://src/scenes/levels/level_1_seccion_b.tscn")
