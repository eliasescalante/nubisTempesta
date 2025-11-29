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
signal player_detected
signal player_lost

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var dialogo = $dialogo
@onready var state_machine_npc: Node = $StateMachineNPC


const TYPE = 'estorbo'

# Esta variable cambia según el TYPE de NPC. En el caso de los NPC-Estorbo es un objeto collectable.
@export var target_desired:String = "chupachups"


var blocked := false

func _ready() -> void:
	dialogo.visible = false
	animated_sprite_2d.play('idle')


func _physics_process(_delta: float) -> void:
	
	move_and_slide()
	
	if velocity.length() > 0:
		animated_sprite_2d.play("idle")
	
	if velocity.x > 0:
		animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.flip_h = true

func _process(delta):
	if blocked:
		return
	# si luego querés darle IA o movimiento, va acá

# ----------------------------------------------------------------------------
# Callback del Area2D en escena que detecta al player.
func _on_chase_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		emit_signal("player_detected")

# Callback del Area2D en escena que detecta al player.
func _on_chase_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		emit_signal("player_lost")

# NPC no decide la transicion.
# solo emite eventos del mundo.

# Lo estados se suscribir a esas señaes cuando entran
# Y se desuscriben al salir.
