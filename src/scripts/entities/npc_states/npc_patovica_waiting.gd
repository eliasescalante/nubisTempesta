extends StateNPCs
class_name NpcPatovicaWaiting

@onready var npc: CharacterBody2D = $"../.."

var player: CharacterBody2D
var body_desactivated = false

var control_point: Node

func enter():
	print("NpcPatovicaWaiting enter")
	
	control_point = npc.return_point
	
	control_point.player_detected.connect(_on_control_point_player_detected)
	body_desactivated = false
	GameState.update_npc_property( npc, 'state', 'NpcPatovicaWaiting' )

func exit():
	print("NpcPatovicaWaiting exit")
	control_point.player_detected.disconnect(_on_control_point_player_detected)
	
func update(_delta: float):
	if not body_desactivated:
		print("Desactivamos el bloqueo de paso")
		npc.velocity = Vector2.ZERO
		npc.body_collision_shape_2d.set_deferred('disabled',true)
		body_desactivated = true

func physics_update(_delta: float):
	pass

func _on_control_point_player_detected():
	print("NpcPatovicaWaiting _on_return_point_player_detected")
	# Acá nos avisa el control_point que el Player ha pasado
	print("Comprobar si cumple los requisitos para pasar o no")
	var target_desired = GameState.get_npc_property( npc, 'target_desired')
	print("target_desired ",target_desired," int(",int(target_desired),")")
	# Si el int(target_desired) == 0 asumimos que es un string
	# y por lo tanto hay que aplicar la logica de PATOVICA-PASS
	print("GameState.pld ", int(GameState.pld))
	# Comprueba PLD (tambien se puede agregar la comprobacion de OBJETO-PASE)
	if  int(GameState.pld) < int(target_desired):
		Transitioned.emit(self, "NpcPatovicaTalking")
	else:
		# forzamos a que se vuelva a desactivar por las dudas
		body_desactivated = false
