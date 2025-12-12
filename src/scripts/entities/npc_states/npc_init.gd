extends StateNPCs
class_name NpcInit

# Apunta al nodo NpcEstorbo (2 parent levels)
#@export var npc: CharacterBody2D = $"../.."
@onready var npc: CharacterBody2D = $"../.."
@onready var state


# Ahora el Init determina usando el 'type' de NPC 
# el comportamiento.
func enter():
	print("STATE NpcInit ENTER")
	print("npc.name ", npc.name)

	state = GameState.get_npc_state(npc)
	print("state ",state)
	
	if state == "null":
		print("El NPC no existe, lo registramos e iniciamos el siguiente estado")
		GameState.register_npc(npc)
	
	if npc.blocked:
		print("El NPC está BLOCKED en la instancia. Desactivar")
		Transitioned.emit(self, "NpcDesactivated")
		return

	# Aquí se determina segun el npc.type
	# 'estorbo' | 'chisme' | 'patovica' (bloqueo) | 'historia'
	if npc.type=='chisme':
		init_chisme()
		return
	
	if npc.type=='patovica':
		init_patovica()
		return

	if npc.type=='patovica-pass':
		init_patovica_pass()
		return
	
	if npc.type=='historia':
		init_historia()
		return
		
	init_estorbo()

func exit():
	pass

func init_estorbo():
	print("Iniciar NPC-ESTORBO")
	if GameState.npc_has_quest(npc):
		print("El NPC tiene la quest completa. Desactivar")
		Transitioned.emit(self, "NpcDesactivated")
		return
	
	if state != "NpcQuestWaiting" or state != "NpcBlocking":
		print("Aunque no era uno de los esperados. Establecemos por defecto 'NpcBlocking'")
		state = "NpcBlocking"
			
	Transitioned.emit(self, state)

func init_chisme():
	print("Iniciar NPC-CHISME")
	Transitioned.emit(self, "NpcChismeWaiting")

func init_patovica():
	print("Iniciar NPC-PATOVICA")
	Transitioned.emit(self, "NpcPatovicaWaiting")

func init_patovica_pass():
	print("Iniciar NPC-PATOVICA-PASS")
	if GameState.npc_has_quest(npc):
		print("El NPC tiene la quest completa. Desactivar")
		Transitioned.emit(self, "NpcDesactivated")
		return
	Transitioned.emit(self, "NpcPatovicaWaiting")

func init_historia():
	if GameState.npc_has_quest(npc):
		print("El NPC tiene la quest completa. Desactivar")
		Transitioned.emit(self, "NpcDesactivated")
		return
	
	if state != "NpcHistoriaQuestWaiting":
		print("Aunque el estado no era uno de los esperados. Establecemos por defecto 'NpcHistoriaQuestWaiting'")
		state = "NpcHistoriaQuestWaiting"
			
	Transitioned.emit(self, state)
