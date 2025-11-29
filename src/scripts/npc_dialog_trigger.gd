extends Area2D
"""
# NPC_DIAGLO_TRIGGER

@onready var npc = get_parent()
@onready var npc_dialogo = npc.get_node("dialogo")
@onready var player : Player = null
@onready var scene_name = GameState.get_current_scene_name()
var dialog_started := false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if dialog_started:
		return

	if body.is_in_group("player"):
		print("Datos NPC ",npc.name," ",GameState.get_npc_data(scene_name, npc.name))
		player = body
		start_dialog()

func start_dialog():
	dialog_started = true

	# Bloquear ambos
	npc.set_process(false)
	player.is_talking = true

	# 🔵 ETAPA 1 → PLAYER HABLA
	player.dialogo.visible = true
	npc_dialogo.visible = false  # NPC callado

	player.play_dialog("necesito pasar...")

	await get_tree().create_timer(1.5).timeout

	# 🔵 ETAPA 2 → NPC HABLA
	player.dialogo.visible = false   # player callado
	npc_dialogo.visible = true

	npc_dialogo.update_text("mmm chupachups y pasar")

	await get_tree().create_timer(1.5).timeout
	GameState.update_npc_state(npc.name, 'quest', true)
	end_dialog()


func end_dialog():
	# Ocultar ambos
	player.dialogo.visible = false
	npc_dialogo.visible = false

	player.is_talking = false
	npc.set_process(true)
	
	dialog_started = false
	#queue_free()
"""
