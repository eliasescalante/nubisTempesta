extends CharacterBody2D
class_name MovingPlatform

# Velocidad de movimiento (pixeles/seg)
@export var speed := 200.0
# Distancia máxima desde la posición inicial antes de cambiar dirección
@export var distance := 512.0

var direction := 1  # 1 = derecha, -1 = izquierda
var start_position := Vector2.ZERO

func _ready():
	start_position = position

func _physics_process(delta: float) -> void:
	# Mover la plataforma horizontalmente
	velocity.x = direction * speed
	velocity.y = 0  # No se mueve verticalmente
	move_and_slide()
	
	# Cambiar de dirección si se pasa de la distancia
	if abs(position.x - start_position.x) >= distance:
		direction *= -1
