extends Node

func _ready() -> void:
	AudioManager.play_main_theme()
	GameState.reset_game_state()
