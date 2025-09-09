extends CanvasLayer

@onready var inventario_slots = [
	$MarginContainer/HBoxContainer/TextureRect,
	$MarginContainer/HBoxContainer/TextureRect2,
	$MarginContainer/HBoxContainer/TextureRect3,
	$MarginContainer/HBoxContainer/TextureRect4,
]
@onready var puntos_label = $MarginContainer/Label

var puntos: int = 0
var inventario: Array = [null, null, null, null] # Guarda los items

func actualizar_puntos(valor: int):
	puntos = valor
	puntos_label.text = "Puntos: %d" % puntos

func agregar_item(item_texture: Texture2D):
	for i in range(inventario.size()):
		if inventario[i] == null:
			inventario[i] = item_texture
			inventario_slots[i].texture = item_texture
			return

func quitar_item(index: int):
	if inventario[index] != null:
		inventario[index] = null
		inventario_slots[index].texture = null
