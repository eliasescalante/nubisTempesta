extends StateNPCs
class_name NpcCapturing

@onready var npc: CharacterBody2D = $"../.."

var player: CharacterBody2D
var hud
var target_desired
var object_used_specimen
var level_node
var return_point: Node
var dont_move: bool = false

func enter():
	print("NpcCapturing enter")
	
	hud = get_tree().get_root().find_child("HudNivel", true, false)
	target_desired = GameState.get_npc_property( npc, 'target_desired')
	return_point = npc.return_point
	
	GameState.update_npc_property( npc, 'state', 'NpcCapturing' )
	dont_move = true
	
	# Referenciar al nodo del nivel para disparar la captura del player
	level_node = get_tree().get_first_node_in_group("levels")
	# Detener a Nubis y poner en modo "Capturada"
	level_node.player_captured()
	# Detener unos segundos mientras esperamos que la cortina tape el escenario
	await get_tree().create_timer(2).timeout
	# Ubicamos al NPC en el punto de retorno
	npc.global_position = return_point.global_position
	Transitioned.emit(self, "NpcQuestWaiting")

func exit():
	print("NpcCapturing exit")
	
func update(delta: float ):
	pass

func physics_update(_delta: float):
	pass
