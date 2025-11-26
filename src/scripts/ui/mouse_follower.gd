extends Node2D

"""
Este nodo realiza el movimiento de camara para el efecto parallax.

El comportamiento es seguir al mouse para mover la cámara.
Pasado una cantidad de tiempo, definido en 'auto_move_delay' se activa
el movimiento automático.

El funcionamiento es mover este nodo que contiene una cámara 
(y un sprite invisible para facilitar el testing) en un área limitada ('limit_x', 'limit_y')
en el centro del viewport proporcional a la posición de mouse en el viewport.
Es decir que si el mouse destá en el extremo derecho del viewport, este nodo
está en el extremo derecho de esa área.
"""

var viewport_size

# Posición inicial del nodo. Centro de la pantalla
var init_x
var init_y

# Guardan la nueva posición del nodo.
var new_x
var new_y

# Determinan el límite en positivo y negativo
# de las coordenadas desde la posición inicial.
# Por defecto 160x90 (320px ancho x 180px alto)
var limit_x = 160
var limit_y = 90

# Control automático de la cámara
var auto_move = true
var auto_move_delay = .5
var auto_move_count = 0

# Distancia de movimiento
var dx = 4
var dy = 2.25

# No se usa, pero lo vamos a dejar por las dudas que haga falta.
var current_pos


func _ready() -> void:
	viewport_size = get_viewport_rect().size
	init_x = viewport_size.x/2
	init_y = viewport_size.y/2
	position.x = init_x
	position.y = init_y
	
# PARALLAX para el arte
func _input(event):
	if event is InputEventMouseMotion:
		auto_move = false
		auto_move_count = 0
		# Capturar posicion de mouse
		var mouse_x = event.position.x
		var mouse_y = event.position.y
		var relative_x = (mouse_x - (viewport_size.x/2)) / (viewport_size.x/2)
		var relative_y = (mouse_y - (viewport_size.y/2)) / (viewport_size.y/2)
		
		#print("relative_x ",relative_x)
		#print("relative_y ",relative_y)
		
		new_x = init_x + ( relative_x * limit_x )
		new_y = init_y + ( relative_y * limit_y )
		#print("new_x ", new_x)
		#print("new_y ", new_y)
		
		if sign(relative_x) == -1:
			dx = abs(dx) * -1
		else:
			dx = abs(dx)
		if sign(relative_y) == -1:
			dy = abs(dy) * -1
		else:
			dy = abs(dy)
		
		position.x = new_x
		position.y = new_y
		current_pos = Vector2(position.x,position.y)

# Automático para la camara
func _process(delta: float) -> void:
	
	if auto_move == false:
		auto_move_count += ( 1 * delta )
		#print("auto_move_count ",auto_move_count)
	
	if auto_move_count > auto_move_delay:
		auto_move = true
		
	if auto_move == true:
		#print("new_x ", new_x)
		#print("new_y ", new_y)
		new_x = position.x + dx
		new_y = position.y + dy
		
		# Comprobamos los límites y corregimos si es necesario
		if new_x > init_x + limit_x or new_x < init_x - limit_x:
			dx  = dx * -1
			new_x = position.x + dx
		if new_y > init_y + limit_y or new_y < init_y - limit_y:
			dy  = dy * -1
			new_y = position.y + dy
			
		# Establecemos la posición
		position.x = new_x
		position.y = new_y
		current_pos = Vector2(position.x,position.y)
