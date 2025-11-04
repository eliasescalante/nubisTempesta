extends Node2D
@onready var label: Label = %Label

func update_text(texto : String):
	label.text = texto
