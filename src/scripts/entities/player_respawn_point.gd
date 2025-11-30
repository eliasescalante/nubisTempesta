extends Node2D

## PUNTO DE REGENERACION PARA EL PLAYER
#
# Este nodo es la coordenada de regeneración del Player tras morir
# o ser capturado
# 
# Cuando el jugador entra al Area2D el Nodo registra su instancia en el 
# GameState.last_respawn_point
# Si no llega a haber ninguno registrado entonces el LEVEL
# busca el mas cercano respecto a la Posición de Muerte o Captura del Player.

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if not get_scene_file_path().is_empty():
			print("El Player entro en Punto de Retorno")
			GameState.set_respawn_point(get_node(get_path()))
