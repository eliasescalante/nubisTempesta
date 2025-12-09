extends Node2D

@onready var introduccion: AudioStreamPlayer = $ost/Introduccion
@onready var nivel_1: AudioStreamPlayer = $ost/Nivel1
@onready var main_theme: AudioStreamPlayer = $ost/MainTheme
@onready var bar: AudioStreamPlayer = $ost/Bar
@onready var game_over: AudioStreamPlayer = $ost/GameOver


func play_main_theme():
	if main_theme:
		main_theme.play()

func play_introduccion():
	if introduccion:
		introduccion.play()
		
func play_nivel_1():
	if nivel_1:
		nivel_1.play()

func stop_nivel_1():
	if nivel_1:
		nivel_1.stop()
		
func play_bar():
	if bar:
		bar.play()

func play_game_over():
	if game_over:
		game_over.play()

func stop_game_over():
	if game_over:
		game_over.stop()
