extends Node2D

## PUNTO DE RETORNO PARA NPC
#
# Este punto es la coordenada de retorno para los NPC-Estorbo
# cuando están en ESTATO RETURNING.
# Hay que vincular la instancia de este nodo en el escenario
# con la propiedad export 'return_point' del NPC.
#
# También es el punto por donde el PLAYER debe pasar para
# desactivar el NPC-Estorbo
# Hay que vincular en el NPC la señal que emite este nodo
# cuando el Player entra en el Area2D

signal player_detected

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		emit_signal("player_detected")
