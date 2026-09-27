class_name Trail_Spawner extends Node3D

const TRAIL_OBJECT_SCENE : PackedScene = preload(ScenePaths.PLAYER.trail_object)


@export var player : Player
@export var timer_max : float = 0.2
var timer_increment : float

var active : bool = false

func _process(delta: float) -> void:
	if active:
		if timer_increment <= 0.0:
			var new_trail_object : Trail_Object = TRAIL_OBJECT_SCENE.instantiate()
			new_trail_object.spawn_position = global_position
			player.get_parent().add_child(new_trail_object)
			
			timer_increment = timer_max
		timer_increment -= delta
	else:
		timer_increment = 0.0
