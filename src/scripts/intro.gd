extends VideoStreamPlayer

func _ready():
	pass
	AudioManager.play_introduccion()

func _process(delta: float) -> void:
	pass

func _on_finished() -> void:
	iniciar()

func _on_button_pressed() -> void:
	stop()
	iniciar()

func iniciar() -> void:
	GameState.portal = 0
	GameState.loader = 2
	GameState.text_loader = "NIVEL 1 - ZONA A"
	GameState.text_loader_subtitulo = "BAJOS PILARES"
	GameState.image_loader_mini = "nivel_1_zona_a"
	AudioManager.get_node("ost/Introduccion").stop()
	get_tree().change_scene_to_file("res://src/scenes/levels/loader.tscn")
