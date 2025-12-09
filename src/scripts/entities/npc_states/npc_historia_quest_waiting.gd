extends StateNPCs
class_name NpcHistoriaQuestWaiting

@onready var npc: CharacterBody2D = $"../.."

var player: CharacterBody2D
var hud
var target_desired
var object_quest_specimen
var dont_move: bool = false

func enter():
	print("NpcHistoriaQuestWaiting enter")
	
	hud = get_tree().get_root().find_child("HudNivel", true, false)
	target_desired = GameState.get_npc_property( npc, 'target_desired')
	npc.dialog_player_detected.connect(_on_dialog_player_detected)
	
	GameState.update_npc_property( npc, 'state', 'NpcHistoriaQuestWaiting' )
	dont_move = true

func exit():
	print("NpcHistoriaQuestWaiting exit")
	npc.dialog_player_detected.disconnect(_on_dialog_player_detected)
	
func update(_delta: float ):
	pass

func physics_update(_delta: float):
	pass

func _on_dialog_player_detected():
	print("NpcHistoriaQuestWaiting _on_dialog_player_detected")
	object_quest_specimen = hud.object_quest_specimen
	if object_quest_specimen == target_desired:
		print("Tienes el OBJETO DE DESEO")
		Transitioned.emit(self, "NpcHistoriaQuestCompleted")
	else:
		Transitioned.emit(self, "NpcHistoriaTalking")
