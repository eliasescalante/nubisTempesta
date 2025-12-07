extends StateNPCs
class_name NpcQuestWaiting

@onready var npc: CharacterBody2D = $"../.."

var player: CharacterBody2D
var hud
var target_desired
var object_used_specimen
var chase_ray_cast_2d: RayCast2D
var return_point: Node
var dont_move: bool = false
var chase_ray_cast_2d_detection = false
func enter():
	print("NpcQuestWaiting enter")
	
	hud = get_tree().get_root().find_child("HudNivel", true, false)
	target_desired = GameState.get_npc_property( npc, 'target_desired')
	return_point = npc.return_point
	chase_ray_cast_2d = npc.chase_ray_cast_2d
	npc.dialog_player_detected.connect(_on_dialog_player_detected)
	npc.chase_player_detected.connect(_on_chase_player_detected)
	return_point.player_detected.connect(_on_return_point_player_detected)
	
	GameState.update_npc_property( npc, 'state', 'NpcQuestWaiting' )
	chase_ray_cast_2d_detection = false
	dont_move = true

func exit():
	print("NpcQuestWaiting exit")
	npc.dialog_player_detected.disconnect(_on_dialog_player_detected)
	npc.chase_player_detected.disconnect(_on_chase_player_detected)
	return_point.player_detected.disconnect(_on_return_point_player_detected)
	
func update(_delta: float ):
	if chase_ray_cast_2d.is_colliding() and not chase_ray_cast_2d_detection:
		var body = chase_ray_cast_2d.get_collider()
		print("CHASE RAY CAST collision detected. body:",body)
		print("¿in group 'player? ", body.is_in_group("player"))
		if body.is_in_group("player"):
			print("CHASE RAY CAST JUGADOR DETECTADO")
			chase_ray_cast_2d_detection = true
			comprobar_objeto_deseo()

func physics_update(_delta: float):
	pass

func _on_dialog_player_detected():
	print("NpcQuestWaiting _on_dialog_player_detected")
	object_used_specimen = hud.object_used_specimen
	if object_used_specimen != target_desired:
		Transitioned.emit(self, "NpcTalking")

func _on_chase_player_detected():
	print("NpcQuestWaiting _on_chase_player_detected")
	# Acá comprobamos si el Player tiene el objeto de deseo
	comprobar_objeto_deseo()

func _on_return_point_player_detected():
	print("NpcQuestWaiting _on_return_point_player_detected")
	# Acá nos avisa el return_point que el Player ha pasado
	# Con lo que desactivamos todo
	dont_move = true
	Transitioned.emit(self, "NpcDesactivated")

func comprobar_objeto_deseo():
	object_used_specimen = hud.object_used_specimen
	if object_used_specimen == target_desired:
		print("Tienes el OBJETO DE DESEO")
		print("Transicion a NpcChasing")
		Transitioned.emit(self, "NpcChasing")
