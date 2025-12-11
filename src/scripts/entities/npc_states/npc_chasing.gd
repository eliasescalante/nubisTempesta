extends StateNPCs
class_name NpcChasing

@onready var npc: CharacterBody2D = $"../.."
@export var move_speed : float = 200.0

var player: CharacterBody2D
var ray_cast_2d: RayCast2D

var hud
var target_desired
var object_used_specimen

var return_point: Node
var dont_move: bool = false
var animation_player: AnimationPlayer

# Al entrar, nos suscribimos a la señal de "player_lost"
# del npc y capturamos el nodo principal del player
func enter():
	print("NpcChasing enter")
	# Conectamos la seña de perdida para poder volver
	# al estado de blockeo (por ahora)
	return_point = npc.return_point
	npc.chase_player_lost.connect(_on_chase_player_lost)
	return_point.player_detected.connect(_on_return_point_player_detected)
	npc.capture_player_detected.connect(_on_capture_player_detected)
	
	# Buscamos al player por grupo
	GameState.update_npc_property( npc, 'state', 'NpcChasing' )
	player = get_tree().get_first_node_in_group("player")
	
	ray_cast_2d = npc.ray_cast_2d
	animation_player = npc.animation_player
	
	hud = get_tree().get_root().find_child("HudNivel", true, false)
	target_desired = GameState.get_npc_property( npc, 'target_desired')
	animation_player.play('chasing')
	# Conectamos para hacer looop
	animation_player.animation_finished.connect(_on_animacion_terminada)
	dont_move = false
	
# Al salir, desconectamos la señal
func exit():
	print("NpcChasing exit")
	npc.chase_player_lost.disconnect(_on_chase_player_lost)
	npc.capture_player_detected.disconnect(_on_capture_player_detected)
	animation_player.animation_finished.disconnect(_on_animacion_terminada)
	
func physics_update(_delta: float):
	
	if dont_move:
		return
	
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
	print("Transicion a NpcReturning")
	Transitioned.emit(self, "NpcReturning")

func _on_return_point_player_detected():
	print("NpcChasing _on_return_point_player_detected")
	# Acá nos avisa el return_point que el Player ha pasado
	# Con lo que desactivamos todo
	dont_move = true
	Transitioned.emit(self, "NpcDesactivated")

func _on_capture_player_detected():
	print("NpcChasing _on_capture_player_detected")
	print("Transicion a NpcCapturing")
	dont_move = true
	Transitioned.emit(self, "NpcCapturing")

func _on_animacion_terminada(anim_name: String) -> void:
	# Hacemos loop de la animación
	if anim_name == "chasing":
		animation_player.play('chasing')
