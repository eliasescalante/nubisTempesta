extends StateNPCs
class_name NpcBlocking

@export var npc: CharacterBody2D
@export var move_speed: float = 100.0

var move_direction := Vector2.ZERO
var change_direction: float = 0.0

func randomizar_movement():
	move_direction = Vector2(randf_range(-1,1), 0.0).normalized()
	change_direction = randf_range(1,3)
	
func enter():
	print("NpcBlocking enter")
	npc.player_detected.connect(_on_player_detected)
	randomizar_movement()

func exit():
	print("NpcBlocking exit")
	npc.player_detected.disconnect(_on_player_detected)

func update(delta: float ):
	if change_direction >0:
		change_direction -= delta	

func physics_update(_delta: float):
	if npc:
		npc.velocity = move_direction * move_speed

func _on_player_detected():
	print("NpcBlocking _on_player_detected")
	print("Transicion a NpcChasing")
	Transitioned.emit(self, "NpcChasing")
