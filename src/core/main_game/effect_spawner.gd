class_name WorldEffectsSpawner extends Node

@onready var effect_root: Node3D = %EffectRoot

var world_effects : Dictionary[EFFECTS, PackedScene]

const SPIN_HIT_VFX = preload("uid://dcrknytfnxlhu")

enum EFFECTS {
	SPINHIT
}

func _ready() -> void:
	world_effects = {
		EFFECTS.SPINHIT : SPIN_HIT_VFX
	}
	
func spawn_one_shot_effect(effect : EFFECTS, location : Vector3) -> void:
	var new_effect : OneShotVFX = world_effects[effect].instantiate() as OneShotVFX
	effect_root.add_child(new_effect)
	new_effect.play_vfx(location)
