extends CharacterBody2D
class_name Player

# --- Constantes base ---
const SPEED_BASE = 300.0
const JUMP_VELOCITY_BASE = -1000.0
const DASH_SPEED = 600.0
const DASH_DURATION = 0.2
const MORTAL_VELOCITY_FALL = 1600.0
const TIME_TO_REGENERATE = 2.0
const PLD_GAME_OVER = -30

# --- Estados ---
var is_dashing := false
var dash_timer := 0.0
var can_double_jump := true
var is_talking := false
var is_dead := false
var is_game_over := false
var velocity_falling := 0.0

# --- Variables PLD ---
@export var pld: int = 30
@export var pld_por_salto: int = 5
@export var pld_por_doble_salto: int = 7
@export var pld_por_dash: int = 10
@export var pld_por_caida: int = 0
@export var pld_por_caida_factor: float = 75.0
@export var pld_por_morir: int = 140
@export var pld_por_tiempo_quieto: int = 1
@export var tiempo_quieto: float = 2.0
@export var tiempo_sin_mover: float = 0.0

@export var tiempo_muerta: float = 0.0

#---- Variables para los dialogos------



# --- Referencias ---
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hud = get_tree().get_current_scene().get_node("HudNivel")

@onready var dialogo: Node2D = %dialogo

signal pld_cambiado(nuevo_pld)

# --- Función para gastar PLD ---
func gastar_pld(cantidad: int):

	pld = max(pld - cantidad, PLD_GAME_OVER)
	
	if hud:
		hud.actualizar_puntos(pld)
	emit_signal("pld_cambiado", pld)
	print("PLD restante:", pld)
	
	if pld <= PLD_GAME_OVER:
		is_dead = true
		is_game_over = true
		print ("Emitir señal 'game_over'")
		emit_signal("game_over")
		#return
# --- Ready ---
func _ready() -> void:
	dialogo.visible = false
	play_anim("idle")

# --- Multiplicador de velocidad / salto según PLD ---
func get_pld_multiplier() -> float:
	
	# para esta etapa inicial de desarrollo lo dejamos sin efecto.
	return 1.0
	# ------------------------
	if pld >= 337 / 2:
		return 1.0
	else:
		# Lineal: PLD=0 → velocidad 50%
		return 0.5 + 0.5 * (pld / (337 / 2))

# --- Physics Process ---
func _physics_process(delta: float) -> void:
	
	if is_game_over == true:
		return
	
	if is_dead == true and is_game_over == false :
		tiempo_muerta += delta
		if tiempo_muerta > TIME_TO_REGENERATE:
			tiempo_muerta = 0.0
			is_dead = false
			regenerar()
		return
		
	# 🛑 Bloqueo total durante diálogo
	if is_talking:
		play_anim("idle") # <-- idle, no caminar
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	var on_floor := is_on_floor()
	var direction := Input.get_axis("ui_left", "ui_right")
	
	# --- Calculamos multiplicador ---
	var multiplier = get_pld_multiplier()
	var SPEED = SPEED_BASE * multiplier
	var JUMP_VELOCITY = JUMP_VELOCITY_BASE * multiplier
	
	# --- Dash ---
	# El dash reduce a la mitad la velocidad de caida
	if Input.is_action_just_pressed("dash") and not is_dashing:
		if pld - pld_por_dash >= PLD_GAME_OVER:
			velocity_falling = velocity_falling / 2
			start_dash(direction)
			gastar_pld(pld_por_dash)
	
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false

	# --- Gravedad ---
	# velocity_falling va registrando la velocidad de caida
	# para calcular la penalidad en PLD al aterrizar.
	if not on_floor and not is_dashing:
		velocity += get_gravity() * delta
		if velocity.y > velocity_falling:
			velocity_falling = velocity.y

	# --- Aterrizar
	if velocity_falling > 0.0 and on_floor:
		print("Aterrizar")
		print("velociad de caida",str(velocity_falling))
		# Determinar si se MUERE o no
		if velocity_falling >= MORTAL_VELOCITY_FALL:
			print('morir')
			is_dead = true
			gastar_pld(pld_por_morir)
		else:
			pld_por_caida = int ( velocity_falling / pld_por_caida_factor )
			print('pld_por_caida', str(pld_por_caida))
			gastar_pld(pld_por_caida)
		velocity_falling = 0.0

	# --- Salto / Doble salto ---
	if Input.is_action_just_pressed("ui_accept"):
		if on_floor:
			if pld - pld_por_salto >= PLD_GAME_OVER:
				velocity.y = JUMP_VELOCITY
				can_double_jump = true
				play_anim("jump")
				gastar_pld(pld_por_salto)
		elif can_double_jump:
			if pld -pld_por_doble_salto >= PLD_GAME_OVER:
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
			
			#=======================================
			# DEV: Esto hay que quitarlo de acá
			# porque es de prueba.
			if is_dead == true:
				print('dejar de hacerse la muerta')
				is_dead = false
			if is_talking == true:
				print('dejar de hablar')
				dialogo.visible = false
				is_talking = false
			#=======================================	
	else:
		tiempo_sin_mover = 0

	if Input.is_action_just_pressed("morir") and on_floor:
		print('morir')
		is_dead = true

	if Input.is_action_just_pressed("hablar") and on_floor:
		print('hablar')
		dialogo.visible = true
		play_dialog("Hola")
		is_talking = true
		
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

func play_dialog(texto : String) -> void:
	# aca poner alguna comprobacion de string
	dialogo.update_text(texto)

func update_animation(on_floor : bool, direction : float) -> void:
	
	if is_dead:
		play_anim("morir")
		return
	if is_talking:
		play_anim("hablar")
		return
	if is_dashing:
		play_anim("dash")
	elif not on_floor:
		if velocity.y < -50:
			if not can_double_jump:
				play_anim("doblejump")
			else:
				play_anim("jump")
		else:
			play_anim("caer")
	elif on_floor and abs(velocity.x) > 10:
		play_anim("caminar")
	else:
		play_anim("idle")

func sumar_pld(cantidad: int):
	pld += cantidad
	if hud:
		hud.actualizar_puntos(pld)
	emit_signal("pld_cambiado", pld)
	print("PLD actual tras sumar:", pld)

func regenerar():
	print("Regenerar a Nubis")
