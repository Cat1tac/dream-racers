extends Node3D

@export var explosions1 : Array[CannonExplosion]
@export var explosions2 : Array[CannonExplosion]
@export var explosionsEnd : Array[CannonExplosion]

var current_explosion1 : CannonExplosion
var current_explosion2 : CannonExplosion
var current_explosion_end : CannonExplosion
var delay_between_arrays : float = 0.8
var interval_between_explosions : float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_explosion1 = explosions1.pick_random()
	current_explosion2 = explosions2.pick_random()
	current_explosion_end = explosionsEnd.pick_random()

func _process(delta: float) -> void:

	if !current_explosion_end.activated:
		current_explosion_end = explosionsEnd.pick_random()
		await get_tree().create_timer(interval_between_explosions).timeout 
		current_explosion_end.activate_explosion_timer()

	if !current_explosion1.activated:
		current_explosion1 = explosions1.pick_random()
		await get_tree().create_timer(interval_between_explosions).timeout 
		current_explosion1.activate_explosion_timer()
	
	await get_tree().create_timer(delay_between_arrays).timeout 
	if !current_explosion2.activated:
		current_explosion2 = explosions2.pick_random()
		await get_tree().create_timer(interval_between_explosions).timeout 
		current_explosion2.activate_explosion_timer()
