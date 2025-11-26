# sfx.gd
extends Node

@onready var _sound_nodes := get_children()

# Diccionario para acceso rápido por nombre
var _sound_dict := {}

func _ready():
	# Diccionario de sonidos
	for child in _sound_nodes:
		if child is AudioStreamPlayer:
			_sound_dict[child.name] = child

func sfx_play(sonido: String) -> void:
	if _sound_dict.has(sonido):
		_sound_dict[sonido].play()
	else:
		print("Sonido no encontrado: " + sonido)

# Detener un sonido específico
func sfx_stop(sonido: String) -> void:
	if _sound_dict.has(sonido):
		_sound_dict[sonido].stop()

# Función para parar todos los sonidos
func sfx_stop_all() -> void:
	for sound in _sound_dict.values():
		sound.stop()

# Oobtener un sonido específico
# Pensado por si a futuro se hacen modificaciones de propiedades dinámicamente
func get_sound(sonido: String) -> AudioStreamPlayer:
	return _sound_dict.get(sonido)

# Verificar si un sonido está reproduciéndose
func is_playing(sonido: String) -> bool:
	if _sound_dict.has(sonido):
		return _sound_dict[sonido].playing
	return false
