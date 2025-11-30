extends StateNPCs
class_name NpcChasing

@export var npc: CharacterBody2D
@export var move_speed : float = 200.0

var player: CharacterBody2D
var ray_cast_2d: RayCast2D

var hud
var target_desired
var object_used_specimen

# Al entrar, nos suscribimos a la señal de "player_lost"
# del npc y capturamos el nodo principal del player
func enter():
	print("NpcChasing enter")
	# Conectamos la seña de perdida para poder volver
	# al estado de blockeo (por ahora)
	npc.chase_player_lost.connect(_on_chase_player_lost)
	# Buscamos al player por grupo
	GameState.update_npc_property( npc, 'state', 'NpcChasing' )
	player = get_tree().get_first_node_in_group("player")
	ray_cast_2d = npc.ray_cast_2d
	
	hud = get_tree().get_root().find_child("HudNivel", true, false)
	target_desired = GameState.get_npc_property( npc, 'target_desired')
	
# Al salir, desconectamos la señal
func exit():
	print("NpcChasing exit")
	npc.chase_player_lost.disconnect(_on_chase_player_lost)
	
func physics_update(_delta: float):
	if not player:
		return
	
	object_used_specimen = hud.object_used_specimen
	if object_used_specimen != target_desired:
		Transitioned.emit(self, "NpcReturning")
	
	var direction
	if ray_cast_2d.is_colliding():
		# Diferencia entre 2 puntos en el plano. ESTO CAMBIARLO SOLO por COORD X
		direction = player.global_position - npc.global_position
		direction.y = 0
		npc.velocity = direction.normalized() * move_speed
	else:
		direction = Vector2.ZERO
		npc.velocity = direction

# Callback cuando el npc detecta que el player se fue
func _on_chase_player_lost():
	print("NpcChasing _on_chase_player_lost")
	#NOTA: aca tenemos que cambiar para NpcReturning
	print("Transicion a NpcReturning")
	Transitioned.emit(self, "NpcReturning")
