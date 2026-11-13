class_name Player_SFX extends Node3D

@onready var driving: AudioStreamPlayer3D = $DriveSFX
#@onready var boosting: AudioStreamPlayer3D = $BoostSFX
@onready var crashing: AudioStreamPlayer3D = $CrashSFX
@onready var charging: AudioStreamPlayer3D = $ChargeSFX
@onready var tricking: AudioStreamPlayer3D = $TrickSFX
@onready var spinning: AudioStreamPlayer3D = $SpinSFX
@onready var rev: AudioStreamPlayer3D = $RevSFX
@onready var hit_sfx: AudioStreamPlayer3D = $HitSFX
@onready var mini_energy_sfx: AudioStreamPlayer3D = $MiniEnergySFX
@onready var big_energy_sfx: AudioStreamPlayer3D = $BigEnergySFX

# MISSING DRIFT

enum SFX {
	DRIVE,
	DRIFT,
	CHARGE,
	SPIN,
	CRASH,
	BOOST,
	TRICK,
	REV,
	HIT,
	MINI,
	BIG
}

var player_top_speed: float

func update_top_speed(speed: float) -> void:
	player_top_speed = speed
	#print("Top speed is " + str(player_top_speed))

func play_audio(request: SFX) -> void:
	match request:
		SFX.DRIVE:
			driving.play()
		SFX.DRIFT:
			#drifting.play()
			pass
		SFX.CHARGE:
			charging.play()
		SFX.SPIN:
			spinning.pitch_scale = randf_range(0.9, 1.1)
			spinning.play()
			pass
		SFX.CRASH:
			crashing.play()
		SFX.BOOST:
			#boosting.play()
			pass
		SFX.TRICK:
			tricking.play()
		SFX.REV:
			rev.play()
		SFX.HIT:
			hit_sfx.play()
		SFX.MINI:
			mini_energy_sfx.play()
		SFX.BIG:
			big_energy_sfx.play()
		_:
			print("AudioError: Tried to play Audio that isn't defined")

func stop_audio(request: SFX) -> void:
	match request:
		SFX.DRIVE:
			driving.stop()
		SFX.DRIFT:
			pass
		SFX.SPIN:
			pass
		SFX.CRASH:
			crashing.stop()
		SFX.BOOST:
			#boosting.stop()
			pass
		_:
			print("AudioError: Tried to play Audio that isn't defined")

#MOSTLY FOR DRIVE AT THE MOMENT SCALE IS FROM 0.5 TO 2.0
func bend_pitch(request: SFX, modifier: float) -> void:
	match request:
		SFX.DRIVE:
			var _min := 0.4 #Minimum pitch bend value
			modifier = (modifier/player_top_speed) * 0.6 + _min
			if modifier > 1.05:
				modifier += 0.3 # Boosts are more noticable
			driving.volume_db = -24.0 + modifier * 5
			driving.pitch_scale = modifier
		SFX.CHARGE:
			modifier = (modifier/20) + 0.8
			charging.pitch_scale = modifier
		SFX.REV:
			rev.volume_db += (modifier - 1) * 10
		_:
			print("AudioError: Tried to bend pitch of undefined sound")
