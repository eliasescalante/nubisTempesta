extends Node2D


@onready var animacion = $cortina/AnimationPlayer
@onready var titulo_label = $titulo_label
@onready var subtitulo_label: Label = $subtitulo_label
@onready var picture_texture_rect: TextureRect = $picture_texture_rect

func _ready() -> void:
	animacion.play("transicion")
	animacion.animation_finished.connect(_on_animacion_terminada)
	titulo_label.text = GameState.text_loader
	subtitulo_label.text = GameState.text_loader_subtitulo
	
	print(GameState.image_loader_mini)
	if GameState.image_loader_mini == null:
		print("Imagen mini en blanco")
		GameState.image_loader_mini = "blank"
	#var image = Image.load_from_file("res://_assets/art/loader_pictures/"+str(GameState.image_loader_mini)+".jpg")
	#var texture = ImageTexture.create_from_image(image)
	var texture = load("res://_assets/art/loader_pictures/"+str(GameState.image_loader_mini)+".jpg")
	
	picture_texture_rect.texture = texture
	
	
func _on_animacion_terminada(anim_name: String) -> void:
	if anim_name == "transicion":
		
		if GameState.game_over:
			# STOP AUDIO GAME OVER
			# Esto no debería estar aca pero es lo que hay
			Sfx.sfx_stop('loader_game_over')
			get_tree().change_scene_to_file("res://src/scenes/main.tscn")
			return
			
		if GameState.loader == 0:
			get_tree().change_scene_to_file("res://src/scenes/levels/intro.tscn")
		elif GameState.loader == 1: # IR AL BAR
			#DEMO - Termina el juego
			get_tree().change_scene_to_file("res://src/scenes/levels/game_completed.tscn")
			#get_tree().change_scene_to_file("res://src/scenes/levels/level_1_the_bar_1.tscn")

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
