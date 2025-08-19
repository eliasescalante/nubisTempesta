extends Node

class_name Level

@export var level_id : int

var level_data : LevelData


func _ready() -> void:
	level_data = LevelManager.get_level_by_id(level_id)
	var musica = ManagerAudio.get_node("Theme/InGame1")
#	if musica.stream is AudioStream:
#		musica.stream.loop = true   # asegura que se repita
	musica.play()
