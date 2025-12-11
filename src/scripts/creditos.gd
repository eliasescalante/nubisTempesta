extends Node2D

@onready var animacion = $cortina/AnimationPlayer
@onready var cortina: CanvasLayer = $cortina

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Animacion cortina entrada")
	animacion.play("entrada")
	animacion.animation_finished.connect(_on_animacion_terminada)
	
	if name=="GameOver":
		AudioManager.play_game_over()

func _on_animacion_terminada(anim_name: String) -> void:
	print("Animacion cortina "+anim_name+" finalizada")
	if anim_name == "entrada":
		# Ocultamos la cortina para habilitar los botones
		cortina.visible = false
	if anim_name == "salida":
		
		if name=="GameOver":
			AudioManager.stop_game_over()
			
		GameState.reset_game_state()
		get_tree().change_scene_to_file("res://src/scenes/main.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	cortina.visible = true
	animacion.play("salida")

func _on_button_2_pressed() -> void:
	OS.shell_open("https://nubis.ar/")
