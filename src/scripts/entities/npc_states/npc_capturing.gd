extends StateNPCs
class_name NpcCapturing


@export var npc: CharacterBody2D

var player: CharacterBody2D
var hud
var target_desired
var object_used_specimen

var return_point: Node
var dont_move: bool = false
