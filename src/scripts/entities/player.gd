extends CharacterBody2D
class_name Player

# --- Constantes base ---
const SPEED_BASE = 300.0
const JUMP_VELOCITY_BASE = -1000.0
const DASH_SPEED = 600.0
const DASH_DURATION = 0.2
const MORTAL_VELOCITY_FALL = 1600.0
const TIME_TO_REGENERATE = 2.0
const PLD_GAME_OVER = -332

# --- Estados ---
var is_dashing := false
var dash_timer := 0.0
var can_double_jump := true
var is_talking := false
var is_in_dialog := false
var is_dead := false
var is_landing := false
var is_dying := false
var is_game_over := false
var is_captured := false
var velocity_falling := 0.0

# --- Variables PLD ---
var pld: int # Esto no tiene que ser @export
@export var pld_por_salto: int = 5
@export var pld_por_doble_salto: int = 7
@export var pld_por_dash: int = 10
@export var pld_por_caida: int = 0
@export var pld_por_caida_factor: float = 75.0
@export var pld_por_morir: int = 140
@export var pld_por_tiempo_quieto: int = 1
@export var tiempo_quieto: float = 2.0
@export var tiempo_sin_mover: float = 0.0
@export var tiempo_aterrizar: float = 0.0
@export var limite_tiempo_aterrizar: float = 0.125
@export var tiempo_muerta: float = 0.0

# --- SFX ---

@onready var sfx_dash: AudioStreamPlayer = $sfx/sfx_dash
@onready var sfx_jump: AudioStreamPlayer = $sfx/sfx_jump
@onready var sfx_tomar_objeto: AudioStreamPlayer = $sfx/sfx_tomar_objeto
@onready var sfx_walking: AudioStreamPlayer = $sfx/sfx_walking
@onready var sfx_landing: AudioStreamPlayer = $sfx/sfx_landing
@onready var sfx_dying: AudioStreamPlayer = $sfx/sfx_dying
@onready var sfx_falling: AudioStreamPlayer = $sfx/sfx_falling
@onready var sfx_gameover: AudioStreamPlayer = $sfx/sfx_gameover
@onready var sfx_idle: AudioStreamPlayer = $sfx/sfx_idle

#---- Variables para los dialogos------



# --- Referencias ---
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hud = get_tree().get_current_scene().get_node("HudNivel")

@onready var dialogo: Node2D = %dialogo

signal pld_cambiado(nuevo_pld)
signal game_over() # Esto lo deberia determinar la logical del LEVEL. Por ahora lo dejo acá
signal player_died()

# --- Función para gastar PLD ---
func gastar_pld(cantidad: int):
	pld = GameState.pld
	pld = max(pld - cantidad, PLD_GAME_OVER)
	
	if hud:
		hud.actualizar_puntos(pld)
	emit_signal("pld_cambiado", pld)
	#print("PLD restante:", pld)
	
	if pld <= PLD_GAME_OVER:
		# Esto es para diferencias entre morir por caida abrupta o por agotamiento.
		if cantidad != pld_por_morir:
			is_landing = false
			is_dying = true
		else:
			is_landing = false
			is_dead = true
		is_game_over = true
		sfx_gameover.play()
		#print ("Emitir señal 'game_over'")
		emit_signal("game_over")
		#return
		
# --- Ready ---
func _ready() -> void:
	dialogo.visible = false
	play_anim("idle")
	pld = GameState.pld

# --- Multiplicador de velocidad / salto según PLD ---
func get_pld_multiplier() -> float:
	pld = GameState.pld
	if pld > 0:
		return 1.0
	else:
		# Lineal: PLD=0 → velocidad 50%
		#return 0.5 + 0.5 * (pld / (337 / 2))
		#return 0.5 + 0.5 * (pld / PLD_GAME_OVER / 2)
		return 0.8

# --- Physics Process ---
func _physics_process(delta: float) -> void:
	
	if is_game_over:
		update_animation(true, 0.0)
		return
	
	if (is_dead or is_dying or is_captured) and not is_game_over:
		# Murio o está muriendo o está capturada
		# y no es game over, entonces regenerar
		update_animation(true, 0.0)
		tiempo_muerta += delta
		if tiempo_muerta > TIME_TO_REGENERATE:
			tiempo_muerta = 0.0
			emit_signal("player_died")
			# Este tiempo de espera esta relacionado con la cortina
			# que demora 0.5 para tapar el escenario
			await get_tree().create_timer(0.7).timeout
			regenerar()
		return
		
	# Hace la animación de hablar solo si está en un diálogo que ha empezado.
	if is_talking and is_in_dialog:
		play_anim("hablar")
	
	# 🛑 Bloqueo total durante diálogo	
	if is_in_dialog: 
		# Separar el is_talking del movimiento permite a futuro 
		# poder hacer hablar a Nubis mientras se mueve
		# (aunque luego se sobre escriba la animacion con movimiento)
		if not is_talking:
			play_anim("idle")
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	
	if is_landing:
		tiempo_aterrizar += delta
		if tiempo_aterrizar >= limite_tiempo_aterrizar:
			tiempo_aterrizar = 0
			is_landing = false
		else:
			return
			
	var on_floor := is_on_floor()
	var direction := (
	Input.get_action_strength("ui_right")
	- Input.get_action_strength("ui_left")
	+ Input.get_action_strength("right")
	- Input.get_action_strength("left")
)

	if GameState.touch_left:
		direction -= 1.0
	if GameState.touch_right:
		direction += 1.0


	
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
			sfx_dash.play()
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

	# --- Cayendo
	if velocity_falling > 0.0 and not on_floor:
		pass
		if not sfx_falling.playing:
			sfx_falling.play()
	# --- Aterrizar
	if velocity_falling > 0.0 and on_floor:
		#print("velociad de caida",str(velocity_falling))
		# Determinar si se MUERE o no
		if velocity_falling >= MORTAL_VELOCITY_FALL:
			#print('morir')
			is_landing = false
			is_dead = true
			sfx_dying.play()
			gastar_pld(pld_por_morir)
		else:
			#print("Aterrizar")
			pld_por_caida = int ( velocity_falling / pld_por_caida_factor )
			#print('pld_por_caida', str(pld_por_caida))
			gastar_pld(pld_por_caida)
			sfx_landing.play()
			is_landing = true
		velocity_falling = 0.0

	# --- Salto / Doble salto ---
	if Input.is_action_just_pressed("ui_accept") or GameState.touch_jump:
		if on_floor:
			if pld - pld_por_salto >= PLD_GAME_OVER:
				velocity.y = JUMP_VELOCITY
				can_double_jump = true
				play_anim("jump")
				sfx_jump.play()
				gastar_pld(pld_por_salto)
		elif can_double_jump:
			if pld -pld_por_doble_salto >= PLD_GAME_OVER:
				velocity.y = JUMP_VELOCITY
				can_double_jump = false
				play_anim("doblejump")
				sfx_jump.play()
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
			#print("Tiempo sin mover gasta PLD")
			gastar_pld(pld_por_tiempo_quieto)
			tiempo_sin_mover = 0
			is_landing = false
			if not sfx_idle.playing:
				# Esta muy sutil. Se podria hacer que suba el voluman a medidas que se acerca a un estado de GAME OVER
				sfx_idle.play()
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

func play_dialog(content : String, content_type: String, balloon_type: String) -> void:
	dialogo.visible = true
	dialogo.update_balloon_type(balloon_type)
	if content_type=='icon':
		dialogo.update_icon_sprite(content)
		return
	dialogo.update_label(content)

func mute_dialog() ->void:
	dialogo.visible = false

func update_animation(on_floor : bool, direction : float) -> void:
	
	if is_dead:
		play_anim("morir")
		return
	if is_dying or is_captured:
		play_anim("decaer")
		return
	if is_landing:
		play_anim("aterrizar")
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
	pld = GameState.pld
	pld += cantidad
	sfx_tomar_objeto.play()
	if hud:
		hud.actualizar_puntos(pld)
	emit_signal("pld_cambiado", pld)
	#print("PLD actual tras sumar:", pld)

func regenerar():
	#print("Regenerar a Nubis")
	is_dead = false
	is_captured = false
	is_dying = false

func captured():
	#print("Nubis Capturada")
	gastar_pld(pld_por_morir)
	is_captured = true # Esto habilita en el _physics_prossed el conteo para regeneracion
