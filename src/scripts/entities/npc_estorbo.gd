extends CharacterBody2D

### NPC-ESTORBO ###

#-------------------------------------------------------------------------------

### ESTADOS Y COMPORTAMIENTOS ##

## INIT: comprueba el estado y la quest en el GameState.
# Verifica en el GameState el diccionario de estado de los NPC
# los datos correspondientes a este NPC.

# DESACTIVATED: deja de tener interacción y física de colisión con el Player.

# BLOCKING: es el estado 'normal' cuando se carga el nivel por primera vez.

# TALKING: mientras el NPC mantiene una secuencia de diálogo con el Player.

# QUEST_WAITING: Espera a que el Player ingrese al Area2D de Chase
# Verifica si el Player está usando el 'target_desired'

# QUEST_COMPLETED: Se establece cuando el Player ha pasado por el Punto de Control.

# CHASING: el Player ingresó al "Área de Colisión de Chase" y tiene en uso el target_desired.

# RETURNING: el jugador ha salido del "Área de Colisión de Chase"
# Vuelve al Punto de Control mientras verifica si el Player vuelve a ingresar
# al área de Chase

# CAPTURING: el NPC colisiona con el Player con el Area de Cuerpo.
# Penalidad y vuelve el estado QUEST_WAITING.

#-------------------------------------------------------------------------------

# Señales que el NPC emite para que los estados escuchen
signal chase_player_detected
signal chase_player_lost
signal dialog_player_detected
signal dialog_player_lost
signal capture_player_detected
signal capture_player_lost

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var dialogo = $dialogo
@onready var state_machine_npc: Node = $StateMachineNPC
@onready var ray_cast_2d: RayCast2D = %RayCast2D
@onready var body_collision_shape_2d: CollisionShape2D = %BodyCollisionShape2D

# El tipo de NPC: 'estorbo', 'bloqueo', 'historia'
@export var type:String = 'estorbo'

# El avance del diálogo entre el NPC y el Player
# 0 - no han hablado todavía
# 1 - han hablado una vez
# el resto de los número pueden varias según sea necesario en el guión. Esto
# permite introducir variedad en diferentes encuentros y estados (situaciones)
@export var dialog_number:int = 0

# Esta variable cambia según el TYPE de NPC.
# En el caso de los NPC-Estorbo es la especie de un objeto collectable.
# En el caso de los NPC-Bloque es un valor numérico de puntos PLD
# En el caso de los NPC-Historia es el nombre de un objeto collectable único.
@export var target_desired:String = "chupachups"

# Vincula el nodo 'Punto_retorno_npc_X' con el NPC
@export var return_point:Node2D

# Por defecto FALSE indica que el NPC no tiene comportamientos.
@export var blocked:bool = false

var is_talking : = false

func _ready() -> void:
	dialogo.visible = false
	animated_sprite_2d.play('idle')


func _physics_process(_delta: float) -> void:

	if blocked:
		animated_sprite_2d.play("idle")
		return

	move_and_slide()
	
	if velocity.length() > 0:
		animated_sprite_2d.play("caminar")
	elif is_talking:
		animated_sprite_2d.play("hablar")
	else:
		animated_sprite_2d.play("idle")

	var ray_cast_pos_x = abs(ray_cast_2d.get_position().x)
	var ray_cast_pos_y = ray_cast_2d.get_position().y
	
	if velocity.x > 0:
		animated_sprite_2d.flip_h = false
		ray_cast_pos_x = ray_cast_pos_x
	else:
		animated_sprite_2d.flip_h = true
		ray_cast_pos_x = -ray_cast_pos_x
	ray_cast_2d.set_position(Vector2(ray_cast_pos_x,ray_cast_pos_y))
	
	
# ----------------------------------------------------------------------------

# Callbacks de las difentes Area2D en escena que detectan al player.

# CHASE AREA
func _on_chase_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		emit_signal("chase_player_detected")

func _on_chase_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		emit_signal("chase_player_lost")

# DIALOG AREA
func _on_dialog_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		emit_signal("dialog_player_detected")

func _on_dialog_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		emit_signal("dialog_player_lost")
	
# CAPTURE AREA
func _on_capture_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		emit_signal("capture_player_detected")

func _on_capture_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		emit_signal("capture_player_lost")



# NPC no decide la transicion.
# solo emite eventos del mundo.

# Lo estados se suscriben a estas señaes cuando entran
# Y se desuscriben al salir.
