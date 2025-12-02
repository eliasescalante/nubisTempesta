extends StateNPCs
class_name NpcQuestWaiting

@export var npc: CharacterBody2D

var player: CharacterBody2D
var hud
var target_desired
var object_used_specimen

var return_point: Node
var dont_move: bool = false

func enter():
	print("NpcQuestWaiting enter")
	
	hud = get_tree().get_root().find_child("HudNivel", true, false)
	target_desired = GameState.get_npc_property( npc, 'target_desired')
	return_point = npc.return_point
	
	npc.dialog_player_detected.connect(_on_dialog_player_detected)
	npc.chase_player_detected.connect(_on_chase_player_detected)
	return_point.player_detected.connect(_on_return_point_player_detected)
	
	GameState.update_npc_property( npc, 'state', 'NpcQuestWaiting' )
	dont_move = true

func exit():
	print("NpcQuestWaiting exit")
	npc.dialog_player_detected.disconnect(_on_dialog_player_detected)
	npc.chase_player_detected.disconnect(_on_chase_player_detected)
	return_point.player_detected.disconnect(_on_return_point_player_detected)
	
func update(delta: float ):
	pass

func physics_update(_delta: float):
	pass

func _on_dialog_player_detected():
	print("NpcQuestWaiting _on_dialog_player_detected")
	object_used_specimen = hud.object_used_specimen
	if object_used_specimen != target_desired:
		Transitioned.emit(self, "NpcTalking")

func _on_chase_player_detected():
	print("NpcQuestWaiting _on_chase_player_detected")
	# Acá comprobamos si el Player tiene el objeto de deseo
	object_used_specimen = hud.object_used_specimen
	if object_used_specimen == target_desired:
		print("Tienes el OBJETO DE DESEO")
		print("Transicion a NpcChasing")
		Transitioned.emit(self, "NpcChasing")

func _on_return_point_player_detected():
	print("NpcQuestWaiting _on_return_point_player_detected")
	# Acá nos avisa el return_point que el Player ha pasado
	# Con lo que desactivamos todo
	dont_move = true
	Transitioned.emit(self, "NpcDesactivated")
