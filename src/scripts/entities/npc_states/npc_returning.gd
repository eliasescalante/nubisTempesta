extends StateNPCs
class_name NpcReturning

@export var npc: CharacterBody2D
@export var move_speed : float = 300.0

var hud
var target_desired
var object_used_specimen

var player: CharacterBody2D
var return_point: Node
var has_returned: bool = false

func enter():
	print("NpcReturning enter")
	
	hud = get_tree().get_root().find_child("HudNivel", true, false)
	target_desired = GameState.get_npc_property( npc, 'target_desired')
	return_point = npc.return_point
	has_returned = false
	
	npc.chase_player_detected.connect(_on_chase_player_detected)
	
	GameState.update_npc_property( npc, 'state', 'NpcReturning' )
	
# Al salir, desconectamos la señal
func exit():
	print("NpcReturning exit")
	npc.chase_player_detected.disconnect(_on_chase_player_detected)
	
func physics_update(_delta: float):
	
	if has_returned:
		return
		
	var direction

	# Diferencia entre 2 puntos en el plano. ESTO CAMBIARLO SOLO por COORD X
	direction = return_point.global_position - npc.global_position
	var dx = abs(return_point.global_position.x - npc.global_position.x)
	direction.y = 0
	npc.velocity = direction.normalized() * move_speed
	
	# Alcanzamos el punto de retorno (no usamos deteccion de colision)
	#print("dx ",dx)
	if dx < 3:
		# Detenemos el movimiento del NPC
		direction = Vector2.ZERO
		npc.velocity = direction
		has_returned = true
		# Y cambiamos de estado.
		Transitioned.emit(self, "NpcQuestWaiting")
		
func _on_chase_player_detected():
	print("NpcReturning _on_chase_player_detected")
	# Acá comprobamos si el Player tiene el objeto de deseo
	object_used_specimen = hud.object_used_specimen
	if object_used_specimen == target_desired:
		print("Tienes el OBJETO DE DESEO")
		print("Transicion a NpcChasing")
		Transitioned.emit(self, "NpcChasing")
