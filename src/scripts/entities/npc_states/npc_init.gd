extends StateNPCs
class_name NpcInit

@export var npc: CharacterBody2D # Apunta al nodo NpcEstorbo (2 parent levels)

@onready var data := {}

func enter():
	print("STATE NpcInit ENTER")
	print("npc.name ", npc.name)

	var state = GameState.get_npc_state(npc)
	print("state ",state)
	
	if state == "null":
		print("El NPC no existe, lo registramos e iniciamos el siguiente estado")
		GameState.register_npc(npc)
	
	if npc.blocked:
		print("El NPC está BLOCKED en la instancia. Desactivar")
		Transitioned.emit(self, "NpcDesactivated")
		return

	if GameState.npc_has_quest(npc):
		print("El NPC tiene la quest completa. Desactivar")
		Transitioned.emit(self, "NpcDesactivated")
		return
		
	if state != "NpcQuestWaiting" or state != "NpcBlocking":
		print("Aunque no era uno de los esperados. Establecemos por defecto 'NpcBlocking'")
		state = "NpcBlocking"
		
	Transitioned.emit(self, state)

func exit():
	pass
		 
