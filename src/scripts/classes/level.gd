extends Node

class_name Level

@export var level_id : int

var level_data : LevelData


func _ready() -> void:
	level_data = LevelManager.get_level_by_id(level_id)
	AudioManager.get_node("ost/Nivel1").play()
