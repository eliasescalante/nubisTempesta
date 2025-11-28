extends CharacterBody2D

### NPC-ESTORBO ###

## ESTADOS Y COMPORTAMIENTOS ##
#
# CHECK: comprueba si tiene o no la quest pendiente en el GAME_STATE
# DESACTIVADO: deja de tener interacción física de colisión con el jugador.
# QUEST_PENDIENTE: es el estado inicial normal. Bloquea el paso y no se puede emover. Solo está activa el "Área de Colisión Cuerpo a Cuerpo".
# QUEST_ACTIVA: espera que el jugador se acerque al "Área de Colisión de Chase" para comprobar si tiene "En uso el Objeto de Deseo".
# MODO_CHASE: el jugador está en el "Área de Colisión de Chase" y tiene "En uso el Objeto de Deseo".
# MODO_RETORNO: el jugador ha salido del "Área de Colisión de Chase" y el NPC está regresando a su posición en el "Punto de Control"
# MODO_CAPTURA: el NPC ha colisionado con el jugador. Penalidad y vuelve el estado QUEST_PENDIENTE.



@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var dialogo = $dialogo

const TYPE = 'estorbo'

# Esta variable cambia según el TYPE de NPC. En el caso de los NPC-Estorbo es un objeto collectable.
@export var target_desired:String = "chupachups"


var blocked := false

func _ready() -> void:
	dialogo.visible = false
	animated_sprite_2d.play('idle')


func _process(delta):
	if blocked:
		return
	# si luego querés darle IA o movimiento, va acá
