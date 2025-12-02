extends StateNPCs
class_name NpcDesactivated

@onready var npc: CharacterBody2D = $"../.."

var body_desactivated = false

func enter():
	print("STATE NpcDesactivated ENTER")
	print("npc.name ", npc.name)
	GameState.update_npc_property( npc, 'state', 'NpcDesactivated' )
	GameState.update_npc_property( npc, 'quest', true )
	
func exit():
	pass
		 
func physics_update(_delta: float):
	pass
	
func update(_delta: float):
	if not body_desactivated:
		npc.velocity = Vector2.ZERO
		npc.body_collision_shape_2d.set_deferred('disabled',true)
		body_desactivated = true
