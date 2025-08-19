extends Node


@export var levels_available : Array[LevelData]
@onready var _2d_scene: Node2D = $"2DScene"


func _ready() -> void:
	LevelManager.main_scene = _2d_scene
	LevelManager.levels = levels_available
	AudioManager.play_intro()
