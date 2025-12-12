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

@onready var dialog_h_box_container: HBoxContainer = %dialog_HBoxContainer


# Recibe el dato de la especie de item
var object_used_specimen
var object_quest_specimen
var object_pass_specimen

@onready var puntos: int = GameState.pld

# para chequear los eventos del touch
func _input(event):
	_check_touch(event)

func _ready() -> void:
	# Funciones para conectar los touch y enviar al gamestate el estado de los mismos
	$Control/left.pressed.connect(func():
		GameState.touch_left = true)
	$Control/left.released.connect(func():
		GameState.touch_left = false)
	$Control/jump.pressed.connect(func():
		GameState.touch_jump = true)
	$Control/jump.released.connect(func():
		GameState.touch_jump = false)
	$Control/dash.pressed.connect(func():
		GameState.touch_dash = true)
	$Control/dash.released.connect(func():
		GameState.touch_dash = true)
	$Control/pause.released.connect(func():
		GameState.touch_pause = true)
	$Control/dialogo_saltar_parte.released.connect(func():
		GameState.touch_dialogo_saltar_parte = true)
	$Control/dialogo_saltar_todo.released.connect(func():
		GameState.touch_dialogo_saltar_todo = true)
	
	pld_icon_animated_sprite_2d.play("default")
	specimen_quest.text = ""
	specimen_pass.text = ""
	specimen_used.text = ""
	puntos_label.text = str(puntos)
	
func actualizar_puntos(valor: int):
	puntos = valor
	puntos_label.text = str(puntos)
	GameState.pld = puntos

func agregar_item(item_texture: Texture2D, item_type: String, item_specimen: String):
	match item_type:
		"used":
			object_used_texture_rect.texture = item_texture
			object_used_specimen = item_specimen
			specimen_used.text = item_specimen
			GameState.item_used = item_specimen
		"quest":
			object_quest_texture_rect.texture = item_texture
			object_quest_specimen = item_specimen
			specimen_quest.text = item_specimen
			GameState.item_quest = item_specimen
		"pass":
			object_pass_texture_rect.texture = item_texture
			object_pass_specimen = item_specimen
			specimen_pass.text = item_specimen
			GameState.item_pass = item_specimen
		_:
			print("⚠️ Tipo de item desconocido: ", item_type)

func update_items_slots_from_game_state():
	pass
	var texture:Texture2D
	texture = load("res://_assets/art/sprites/item_"+GameState.item_used+".png")
	agregar_item(texture, 'used', GameState.item_used)
	texture = load("res://_assets/art/sprites/item_"+GameState.item_quest+".png")
	agregar_item(texture, 'quest', GameState.item_quest)
	texture = load("res://_assets/art/sprites/item_"+GameState.item_pass+".png")
	agregar_item(texture, 'pass', GameState.item_pass)

func actualizar_nivel_y_zona(nivel: String, zona: String) -> void:
	nivel_label.text = nivel
	zona_label.text = zona

func show_dialog_controls():
	dialog_h_box_container.visible = true

func hide_dialog_controls():
	dialog_h_box_container.visible = false
	
func _check_touch(event):
		# TOUCH: dedo toca la pantalla
		if event is InputEventScreenTouch:
			if event.pressed:
				_handle_press(event.position)
				return

		# MOUSE: clic izquierdo = toque
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				_handle_press(event.position)
				return

func _handle_press(pos: Vector2):
	# revisar cada icono si fue tocado
	if doble_jump_texture_rect.get_global_rect().has_point(pos):
		print("TOCADO: Doble Jump")
	if dash_texture_rect.get_global_rect().has_point(pos):
		print("TOCADO: Dash")
	if object_used_texture_rect.get_global_rect().has_point(pos):
		print("TOCADO: Objeto Used")
	if object_quest_texture_rect.get_global_rect().has_point(pos):
		print("TOCADO: Objeto Quest")
	if object_pass_texture_rect.get_global_rect().has_point(pos):
		print("TOCADO: Objeto Pass")
