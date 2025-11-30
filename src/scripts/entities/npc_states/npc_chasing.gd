extends StateNPCs
class_name NpcChasing

@export var npc: CharacterBody2D
@export var move_speed : float = 200.0

var player: CharacterBody2D

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

# Al salir, desconectamos la señal
func exit():
	print("NpcChasing exit")
	npc.chase_player_lost.disconnect(_on_chase_player_lost)
	
func physics_update(_delta: float):
	if not player:
		return
	
	# Diferencia entre 2 puntos en el plano. ESTO CAMBIARLO SOLO por COORD X
	var direction = player.global_position - npc.global_position
	direction.y = 0
	npc.velocity = direction.normalized() * move_speed


# Callback cuando el npc detecta que el player se fue
func _on_chase_player_lost():
	print("NpcChasing _on_chase_player_lost")
	print("Transicion a NpcBlocking")
	Transitioned.emit(self, "NpcBlocking")
