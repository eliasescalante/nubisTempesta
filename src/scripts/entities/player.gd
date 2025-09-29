extends CharacterBody2D
class_name Player

# --- Constantes base ---
const SPEED_BASE = 300.0
const JUMP_VELOCITY_BASE = -900.0
const DASH_SPEED = 600.0
const DASH_DURATION = 0.2

# --- Estados ---
var is_dashing := false
var dash_timer := 0.0
var can_double_jump := true

# --- Variables PLD ---
@export var pld: int = 337
@export var pld_por_salto: int = 5
@export var pld_por_doble_salto: int = 7
@export var pld_por_dash: int = 10
@export var pld_por_tiempo_quieto: int = 1
@export var tiempo_quieto: float = 1.0

var tiempo_sin_mover: float = 0.0

# --- Referencias ---
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hud = get_tree().get_current_scene().get_node("HudNivel")  # Ajusta si es necesario

# --- Señal para HUD (opcional, si quieres dinámico sin depender de la variable hud) ---
signal pld_cambiado(nuevo_pld)

# --- Función para gastar PLD ---
func gastar_pld(cantidad: int):
	if pld <= 0:
		return
	pld = max(pld - cantidad, 0)
	if hud:
		hud.actualizar_puntos(pld)
	emit_signal("pld_cambiado", pld)
	print("PLD restante:", pld)

# --- Ready ---
func _ready() -> void:
	play_anim("idle")

# --- Multiplicador de velocidad / salto según PLD ---
func get_pld_multiplier() -> float:
	if pld >= 337 / 2:
		return 1.0
	else:
		# Lineal: PLD=0 → velocidad 50%
		return 0.5 + 0.5 * (pld / (337 / 2))

# --- Physics Process ---
func _physics_process(delta: float) -> void:
	var on_floor := is_on_floor()
	var direction := Input.get_axis("ui_left", "ui_right")
	
	# --- Calculamos multiplicador ---
	var multiplier = get_pld_multiplier()
	var SPEED = SPEED_BASE * multiplier
	var JUMP_VELOCITY = JUMP_VELOCITY_BASE * multiplier
	
	# --- Dash ---
	if Input.is_action_just_pressed("dash") and not is_dashing:
		if pld >= pld_por_dash:
			start_dash(direction)
			gastar_pld(pld_por_dash)
	
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false

	# --- Gravedad ---
	if not on_floor and not is_dashing:
		velocity += get_gravity() * delta

	# --- Salto / Doble salto ---
	if Input.is_action_just_pressed("ui_accept"):
		if on_floor:
			if pld >= pld_por_salto:
				velocity.y = JUMP_VELOCITY
				can_double_jump = true
				play_anim("jump")
				gastar_pld(pld_por_salto)
		elif can_double_jump:
			if pld >= pld_por_doble_salto:
				velocity.y = JUMP_VELOCITY
				can_double_jump = false
				play_anim("doblejump")
				gastar_pld(pld_por_doble_salto)

	# --- Movimiento horizontal ---
	if not is_dashing:
		if direction != 0:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	if direction != 0:
		animated_sprite_2d.flip_h = direction < 0

	# --- Gasto PLD por estar quieto ---
	if direction == 0 and on_floor:
		tiempo_sin_mover += delta
		if tiempo_sin_mover >= tiempo_quieto:
			gastar_pld(pld_por_tiempo_quieto)
			tiempo_sin_mover = 0
	else:
		tiempo_sin_mover = 0

	move_and_slide()
	update_animation(on_floor, direction)

# --- Dash ---
func start_dash(direction : float) -> void:
	if direction == 0:
		return
	is_dashing = true
	dash_timer = DASH_DURATION
	velocity.x = direction * DASH_SPEED
	velocity.y = 0
	play_anim("dash")

# --- Animaciones ---
func play_anim(name : String) -> void:
	if animated_sprite_2d.animation != name:
		animated_sprite_2d.play(name)

func update_animation(on_floor : bool, direction : float) -> void:
	if is_dashing:
		play_anim("dash")
	elif not on_floor:
		if velocity.y < -50:
			if not can_double_jump:
				play_anim("doblejump")
			else:
				play_anim("jump")
		else:
			play_anim("jump")
	elif on_floor and abs(velocity.x) > 10:
		play_anim("moving")
	else:
		play_anim("idle")
