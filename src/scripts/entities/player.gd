extends CharacterBody2D

class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -900.0
const DASH_SPEED = 600.0
const DASH_DURATION = 0.2

var is_dashing := false
var dash_timer := 0.0
var can_double_jump := true


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	play_anim("idle")


func _physics_process(delta: float) -> void:
	var on_floor := is_on_floor()
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if Input.is_action_just_pressed("dash") and not is_dashing:
		start_dash(direction)
	
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
	
	if not is_on_floor() and not is_dashing:
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept"):
		if on_floor:
			velocity.y = JUMP_VELOCITY
			can_double_jump = true
			play_anim("jump")
		elif can_double_jump:
			velocity.y = JUMP_VELOCITY
			can_double_jump = false
			play_anim("doblejump")
	
	if not is_dashing:
		if direction != 0:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if direction != 0:
		animated_sprite_2d.flip_h = direction < 0
	
	
	update_animation(on_floor, direction)
	
	move_and_slide()


func start_dash(direction : float) -> void:
	if direction == 0:
		return
	
	is_dashing = true
	dash_timer = DASH_DURATION
	velocity.x = direction * DASH_SPEED
	velocity.y = 0
	play_anim("dash")


func play_anim(name : String) -> void:
	if  animated_sprite_2d.animation != name:
		animated_sprite_2d.play(name)


func update_animation(on_floor : bool, direction : float) -> void:
	if is_dashing:
		play_anim("dash")
	elif not on_floor:
		play_anim("jump")
	elif abs(velocity.x) > 10:
		play_anim("moving")
	else:
		play_anim("idle")
