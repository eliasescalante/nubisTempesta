extends StateNPCs
class_name NpcDesactivated

@export var npc: CharacterBody2D # Apunta al nodo NpcEstorbo (2 parent levels)

func enter():
	print("STATE NpcDesactivated ENTER")
	print("npc.name ", npc.name)
	GameState.update_npc_property( npc, 'state', 'NpcDesactivated' )
	GameState.update_npc_property( npc, 'quest', true )
	npc.set_process_mode(PROCESS_MODE_DISABLED)
	# AQUI DEBERIAMOS BUSCAR UNA ALTERNATIVA PARA NO FRENAR TODOS LOS PROCESO
	# SOLO QUITAR LA FISICA PERO DEJAR LA ANIMACION
	# AHORA MISMO QUEDA CONGELADO EL BICHO.
	
func exit():
	pass
		 
func physics_update(_delta: float):
	pass
	
func update(_delta: float):
	pass
