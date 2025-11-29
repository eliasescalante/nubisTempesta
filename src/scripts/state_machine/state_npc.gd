extends Node
class_name StateNPCs

# State Machine para NPC
# Clase 17/11/2025 
# https://www.youtube.com/watch?v=YG-ZfOKJ4ZY
# min 48:39


# Señal que los estados van a usar para pedir un cambio.
# Ej. de emisor : Transmitioned.emit(self, <nombre_estado_target>)
signal Transitioned


# Métodos virtuales / hooks que cada estado va a utilizar
# Se van a definir vacíos para que los hijos implementen opcionalmente

# Se va a llamar cuando un estado se vuelve activo Inicialización local del estado
func enter(): pass


# Se va a llamar cuando se sale de un estado. Limpieza local
# Desconectar señales, reset de nodos, etc
func exit():pass

# Se va a llamar en cada frame (sin físicas)
# temporizadores, lógica no física, animaciones
func update(_delta: float ): pass

# Se va a llamar en cada update de físicas
# ej: mover un cuerpo, aplicar fuerzas, etc.
func physics_update(_delta: float): pass

# Machete \

# State es unidad más pequeña: básicamente nos define la API.

# La señal es la única forma (en este ejemplo) estandar para 
# que un estado pida cambiar a otro estado (desacopla la 
# state machine de la logica inerna)
#
# NO!! poner la lógica de escena directamente
# Los estados concretos se definen aparte.
