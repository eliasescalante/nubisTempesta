extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var dialogo = $dialogo

var blocked := false

func _ready() -> void:
	dialogo.visible = false
	animated_sprite_2d.play('idle')


func _process(delta):
	if blocked:
		return
	# si luego querés darle IA o movimiento, va acá
