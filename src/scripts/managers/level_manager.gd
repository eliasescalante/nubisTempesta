extends Node


var levels : Array[LevelData]
var main_scene : Node2D = null
var loaded_level : Level = null


func unload_level() -> void:
	if is_instance_valid(loaded_level):
		loaded_level.queue_free()
	
	loaded_level = null


func load_level(level_id : int) -> void:
	unload_level()
	
	var level_data = get_level_by_id(level_id)
	
	if not level_data:
		return
	
	var level_path = "res://src/scenes/%s.tscn" %level_data.level_path
	var level_res := load(level_path)
	
	if level_res:
		loaded_level = level_res.instantiate()
		
		main_scene.add_child(loaded_level)
	else:
		print("Nivel inexistente")


func get_level_by_id(level_id : int) -> LevelData:
	var level_returning : LevelData = null
	
	for level : LevelData in levels:
		if level.level_id == level_id:
			level_returning = level
	
	return level_returning
