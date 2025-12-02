extends StateNPCs
class_name NpcPatovicaBlocking

@onready var npc: CharacterBody2D = $"../.."

var player: CharacterBody2D
var body_activated = false

var control_point: Node

func enter():
	print("NpcPatovicaBlocking enter")
	
	control_point = npc.return_point
	
	control_point.player_detected.connect(_on_control_point_player_detected)
	body_activated = false
	GameState.update_npc_property( npc, 'state', 'NpcPatovicaBlocking' )

func exit():
	print("NpcPatovicaBlocking exit")
	control_point.player_detected.disconnect(_on_control_point_player_detected)
	
func update(_delta: float):
	if not body_activated:
		npc.velocity = Vector2.ZERO
		npc.body_collision_shape_2d.set_deferred('disabled',false)
		body_activated = true

func physics_update(_delta: float):
	pass

func _on_control_point_player_detected():
	print("NpcPatovicaBlocking _on_return_point_player_detected")
	# Acá nos avisa el control_point que el Player ha pasado
	print("Comprobar si cumple los requisitos para pasar o no")
	var target_desired = GameState.get_npc_property( npc, 'target_desired')
	print("target_desired ",int(target_desired))
	print("GameState.pld ", int(GameState.pld))
	# Comprueba PLD (tambien se puede agregar la comprobacion de OBJETO-PASE)
	if  int(GameState.pld) < int(target_desired):
		# forzamos al updat que vuelva a activar el bloqueo
		body_activated = false
		await get_tree().create_timer(0.25).timeout
		Transitioned.emit(self, "NpcPatovicaTalking")
	else:
		print("CUMPLE REQUISITOS PARA ENTRAR. NOS PONEMOS EN WAITING")
		Transitioned.emit(self, "NpcPatovicaWaiting")
