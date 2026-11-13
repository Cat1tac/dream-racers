class_name Item extends Node3D

@export var animation_player : AnimationPlayer
@export var sfx : SFX

@export var animation : StringName
## changes boost timer by this amount, can set timer above normal max
@export var time_amt : float = 0.5
## how long the item will stay despawned
@export var despawn_length: float = 2
## boost level to set kart to (behaves as if the kart chaged to this amount normally)
@export var set_boost_lvl : Kart_Sphere.BOOST_LEVEL

@export var area_3d: Area3D

enum SFX {
	MINI,
	BIG
}

var despawn_increment : float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play(animation)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if despawn_increment > 0:
		self.hide()
		despawn_increment -= delta
	else:
		self.show()
		despawn_increment = 0
			
func _physics_process(delta: float) -> void:
	if area_3d.area_entered:
		for area in area_3d.get_overlapping_areas():
			if area is SpinHurtBox:
				_do_item_effect(area as SpinHurtBox)
				
func _do_item_effect(area : SpinHurtBox) -> void:
	despawn_increment = despawn_length
	var kart : Kart_Sphere = area.kart_sphere
	if sfx == SFX.MINI:
		kart.audio_player.play_audio(kart.audio_player.SFX.MINI)
	else:
		kart.audio_player.play_audio(kart.audio_player.SFX.BIG)
		
	if set_boost_lvl > kart.BOOST_LEVEL.ZERO:
		kart.execute_boost(set_boost_lvl, false, false)
		
	if kart.current_boost_level > kart.BOOST_LEVEL.ZERO:
		kart.boost_timer = max(0, kart.boost_timer + time_amt)
