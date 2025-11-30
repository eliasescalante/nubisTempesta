extends StateNPCs
class_name NpcBlocking

@export var npc: CharacterBody2D

#-------------------------------------------------------------------------------
# NOTA En esta versión del juego 
# los NPC-Estorbo están quietos
# pero a futuro se podrían mover un poco como patrullando.
@export var move_speed: float = 0.0
var move_direction := Vector2.ZERO
var change_direction: float = 0.0
#-------------------------------------------------------------------------------

func enter():
	print("NpcBlocking enter")
	npc.dialog_player_detected.connect(_on_dialog_player_detected)
	GameState.update_npc_property( npc, 'state', 'NpcBlocking' )

func exit():
	print("NpcBlocking exit")
	npc.dialog_player_detected.disconnect(_on_dialog_player_detected)

func update(delta: float ):
	pass

func physics_update(_delta: float):
	pass

func _on_dialog_player_detected():
	print("NpcBlocking _on_dialog_player_detected")
	#print("Transicion a NpcChasing")
	#Transitioned.emit(self, "NpcChasing")
	Transitioned.emit(self, "NpcTalking")
