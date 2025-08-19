extends Node2D

@onready var introduccion: AudioStreamPlayer = $ost/Introduccion
@onready var nivel_1: AudioStreamPlayer = $ost/Nivel_1


func play_intro():
	if introduccion:
		introduccion.play()
		
func play_nivel_1():
	if nivel_1:
		nivel_1.play()
