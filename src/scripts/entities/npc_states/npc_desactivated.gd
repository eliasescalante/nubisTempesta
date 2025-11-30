extends StateNPCs
class_name NpcDesactivated

@export var npc: CharacterBody2D # Apunta al nodo NpcEstorbo (2 parent levels)

func enter():
	print("STATE NpcDesactivated ENTER")
	print("npc.name ", npc.name)
	GameState.update_npc_data( npc, 'state', 'NpcDesactivated' )
	GameState.update_npc_data( npc, 'quest', true )
	npc.set_process_mode(PROCESS_MODE_DISABLED)
	
func exit():
	pass
		 
func physics_update(_delta: float):
	pass
	
func update(_delta: float):
	pass
