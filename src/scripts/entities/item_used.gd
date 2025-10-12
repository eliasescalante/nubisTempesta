extends Node2D

@export var pld_bonus: int = 100
@export var item_type : String = "used"

func _on_area_2d_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		var hud = get_tree().get_root().find_child("HudNivel", true, false)
		if hud:
			hud.agregar_item($Sprite2D.texture, item_type)
		
		if body.has_method("sumar_pld"):
			body.sumar_pld(pld_bonus)

		queue_free()
		print("✅ Se agregó al HUD:", item_type)
