extends Control

class_name MainMenu

@onready var animacion = $cortina/AnimationPlayer
@onready var cortina: CanvasLayer = $cortina

var ir_a = ""

func _ready() -> void:
	animacion.play("entrada")
	animacion.animation_finished.connect(_on_animacion_terminada)
	
func _on_animacion_terminada(anim_name: String) -> void:
	print("Animacion cortina "+anim_name+" finalizada")
	if anim_name == "entrada":
		# Ocultamos la cortina para habilitar los botones
		cortina.visible = false
	if anim_name == "salida":
		if ir_a == "juego":
			AudioManager.get_node("ost/Introduccion").stop()
			
			GameState.portal = 0
			GameState.loader = 0
			GameState.text_loader = "NIVEL 1"
			GameState.text_loader_subtitulo = "EL 'PLD' DE CADA DÍA"
			GameState.image_loader_mini = "nivel_1"
			get_tree().change_scene_to_file("res://src/scenes/levels/loader.tscn")
			deactivate()
		elif ir_a == "creditos":
			get_tree().change_scene_to_file("res://src/scenes/levels/creditos.tscn")
	
func _on_play_button_pressed() -> void:
	#LevelManager.load_level(3)
	#get_tree().change_scene_to_file("res://src/scenes/levels/intro.tscn")
	
	cortina.visible = true
	animacion.play("salida")
	ir_a = "juego"
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()


func deactivate() -> void:
	#hide()
	set_process(false)
	set_process_unhandled_input(false)
	set_process_input(false)
	set_physics_process(false)


func activate() -> void:
	#show()
	set_process(true)
	set_process_unhandled_input(true)
	set_process_input(true)
	set_physics_process(true)


func _on_credits_button_pressed() -> void:
	cortina.visible = true
	animacion.play("salida")
	ir_a = "creditos"
