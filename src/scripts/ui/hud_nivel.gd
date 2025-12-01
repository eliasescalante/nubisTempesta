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
@onready var specimen_used: Label = %specimen_Used
@onready var specimen_quest: Label = %specimen_Quest
@onready var specimen_pass: Label = %specimen_Pass

var object_used_specimen # Recibe el dato de la especia de item

var puntos: int = 0

func _ready() -> void:
	pld_icon_animated_sprite_2d.play("default")
	# Estos por ahora no se usan
	specimen_quest.text = ""
	specimen_pass.text = ""
	# Este si
	specimen_used.text = ""
	
func actualizar_puntos(valor: int):
	puntos = valor
	puntos_label.text = str(puntos)

func agregar_item(item_texture: Texture2D, item_type: String, item_specimen: String):
	match item_type:
		"used":
			object_used_texture_rect.texture = item_texture
			object_used_specimen = item_specimen
			specimen_used.text = item_specimen
		"quest":
			object_quest_texture_rect.texture = item_texture
		"pass":
			object_pass_texture_rect.texture = item_texture
		_:
			print("⚠️ Tipo de item desconocido: ", item_type)

func actualizar_nivel_y_zona(nivel: String, zona: String) -> void:
	nivel_label.text = nivel
	zona_label.text = zona
