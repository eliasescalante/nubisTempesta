extends Node


@export var levels_available : Array[LevelData]
@onready var _2d_scene: Node2D = $"2DScene"


func _ready() -> void:
	LevelManager.main_scene = _2d_scene
	LevelManager.levels = levels_available
<<<<<<< HEAD
	ManagerAudio.play_intro()
=======
	ManagerAudio.get_node("Theme/Intro1").play()
	
>>>>>>> 7f4a3b39349d31745dc37758fadcd1da2be8f605
