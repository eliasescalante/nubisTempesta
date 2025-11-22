extends Node2D

"""
Este nodo realiza el movimiento de camara para el efecto parallax.

Sigue el mouse pero si pasan 0.5 seg se activa un automático.
"""

var init_x
var init_y
var new_x
var new_y
var limit_x = 160
var limit_y = 90
var auto_move = true
var dx = 3
var dy = 1
var auto_move_delay = .5
var auto_move_count = 0
var current_pos

var viewport_size

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
		
		print("relative_x ",relative_x)
		print("relative_y ",relative_y)
		
		new_x = init_x + ( relative_x * limit_x )
		new_y = init_y + ( relative_y * limit_y )
		print("new_x ", new_x)
		print("new_y ", new_y)
		
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

func _process(delta: float) -> void:
	
	if auto_move == false:
		auto_move_count += ( 1 * delta )
		print("auto_move_count ",auto_move_count)
	
	if auto_move_count > auto_move_delay:
		auto_move = true
		
	if auto_move == true:
		print("new_x ", new_x)
		print("new_y ", new_y)
		new_x = position.x + dx
		new_y = position.y + dy
		
		if new_x > init_x + limit_x or new_x < init_x - limit_x:
			dx  = dx * -1
			new_x = position.x + dx
		if new_y > init_y + limit_y or new_y < init_y - limit_y:
			dy  = dy * -1
			new_y = position.y + dy
			
		position.x = new_x
		position.y = new_y
		current_pos = Vector2(position.x,position.y)
