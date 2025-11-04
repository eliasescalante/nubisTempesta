extends Node2D

signal item_collected(item_scene_path: String, position: Vector2)

@export var pld_bonus: int = 1000
@export var item_type : String = "used"

func _ready() -> void:
	if not get_scene_file_path().is_empty():
		set_meta("scene_path", get_scene_file_path())


func _on_area_2d_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		var hud = get_tree().get_root().find_child("HudNivel", true, false)
		if hud:
			hud.agregar_item($Sprite2D.texture, item_type)
		
		if body.has_method("sumar_pld"):
			body.sumar_pld(pld_bonus)
		
		# En lugar de borrarnos, avisamos al nivel
		emit_signal("item_collected", get_meta("scene_path"), global_position)
		queue_free()
		print("✅ Se agregó al HUD:", item_type)
