extends Node2D
@onready var label: Label = %Label
@onready var icon_sprite: AnimatedSprite2D = $icon_sprite
@onready var balloon_type: AnimatedSprite2D = $balloon_type

func update_label(text):
	label.text = text
	label.visible = true
	icon_sprite.visible = false

func update_icon_sprite(icon):
	icon_sprite.play(icon)
	label.visible = false
	icon_sprite.visible = true

func update_balloon_type(type):
	balloon_type.play(type)
