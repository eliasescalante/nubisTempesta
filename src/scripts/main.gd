extends Node

@onready var animacion = $cortina/AnimationPlayer
@onready var cortina: CanvasLayer = $cortina

func _ready() -> void:
	AudioManager.play_intro()
	animacion.play("entrada")
	animacion.animation_finished.connect(_on_animacion_terminada)
	
func _on_animacion_terminada(anim_name: String) -> void:
	print("Animacion cortina "+anim_name+" finalizada")
	# Ocultamos la cortina para habilitar los botones
	cortina.visible = false
