extends StateNPCs
class_name NpcTalking

@export var npc: CharacterBody2D

#-------------------------------------------------------------------------------
# NOTA En esta versión del juego 
# cada vez que hay dialogo los personajes están quietos
# pero a futuro se podrían mover.
@export var move_speed: float = 0.0
var move_direction := Vector2.ZERO
var change_direction: float = 0.0
#-------------------------------------------------------------------------------

var dialog_number

func enter():
	print("NpcTalking enter")
	npc.dialog_player_lost.connect(_on_dialog_player_lost)
	GameState.update_npc_property( npc, 'state', 'NpcTalking' )
	dialog_number = GameState.get_npc_property( npc, 'dialog_number')
	npc.is_talking = true

func exit():
	print("NpcTalking exit")
	npc.dialog_player_lost.disconnect(_on_dialog_player_lost)
	npc.is_talking = false

func update(delta: float ):
	pass

func physics_update(_delta: float):
	pass

func _on_dialog_player_lost():
	print("NpcTalking _on_dialog_player_lost")
	Transitioned.emit(self, "NpcBlocking")
