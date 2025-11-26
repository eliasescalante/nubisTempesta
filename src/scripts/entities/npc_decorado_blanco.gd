extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	# Aqui poner variaciones de especies
	animated_sprite_2d.play('especie_1')
