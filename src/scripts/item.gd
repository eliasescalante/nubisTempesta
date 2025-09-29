extends Node2D

@export var item_texture: Sprite2D

func _ready():
	if item_texture:
		$Sprite2D.texture = item_texture.texture

func _on_area_2d_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		var hud = get_tree().get_current_scene().get_node("hud")
		if hud and item_texture:
			hud.agregar_item(item_texture.texture)
		queue_free()
		print("Textura que se agrega:", item_texture.texture)
		print("HUD encontrado:", hud)
