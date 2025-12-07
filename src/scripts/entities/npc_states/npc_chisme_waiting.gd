extends StateNPCs
class_name NpcChismeWaiting

@export var npc: CharacterBody2D

var player: CharacterBody2D
var body_desactivated = false

func enter():
	print("NpcChismeWaiting enter")
	npc.dialog_player_detected.connect(_on_dialog_player_detected)
	GameState.update_npc_property( npc, 'state', 'NpcChismeWaiting' )

func exit():
	print("NpcChismeWaiting exit")
	npc.dialog_player_detected.disconnect(_on_dialog_player_detected)
	
func update(_delta: float):
	if not body_desactivated:
		npc.velocity = Vector2.ZERO
		npc.body_collision_shape_2d.set_deferred('disabled',true)
		body_desactivated = true

func physics_update(_delta: float):
	pass

func _on_dialog_player_detected():
	print("NpcChismeWaiting _on_dialog_player_detected")
	Transitioned.emit(self, "NpcChismeTalking")
