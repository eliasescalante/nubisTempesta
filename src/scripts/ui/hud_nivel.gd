extends CanvasLayer

@onready var nivel_label: Label = %level_label
@onready var zona_label: Label = %zone_label

@onready var doble_jump_texture_rect: TextureRect = %dobleJump_TextureRect
@onready var dash_texture_rect: TextureRect = %dash_TextureRect

@onready var pld_icon_animated_sprite_2d: AnimatedSprite2D = %pldIcon_AnimatedSprite2D
@onready var puntos_label: Label = %pldPoints_label

@onready var object_used_texture_rect: TextureRect = %objectUsed_TextureRect
@onready var object_quest_texture_rect: TextureRect = %objectQuest_TextureRect
@onready var object_pass_texture_rect: TextureRect = %objectPass_TextureRect



var puntos: int = 0
var inventario: Array = [null, null, null, null] # Guarda los items

func _ready() -> void:
	pld_icon_animated_sprite_2d.play("default")
	
func actualizar_puntos(valor: int):
	print("actualizar_puntos"+str(valor))
	puntos = valor
	puntos_label.text = "%d" % puntos

func agregar_item(item_texture: Texture2D):
	
	#for i in range(inventario.size()):
	#	if inventario[i] == null:
	#		inventario[i] = item_texture
	#		inventario_slots[i].texture = item_texture
	#		return
	
	return

func quitar_item(index: int):
	#if inventario[index] != null:
	#	inventario[index] = null
	#	inventario_slots[index].texture = null
	return
