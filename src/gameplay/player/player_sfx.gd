extends Node3D

@onready var driving: AudioStreamPlayer3D = $DriveSFX
#@onready var boosting: AudioStreamPlayer3D = $BoostSFX
@onready var crashing: AudioStreamPlayer3D = $CrashSFX
@onready var charging: AudioStreamPlayer3D = $ChargeSFX
@onready var tricking: AudioStreamPlayer3D = $TrickSFX
# MISSING DRIFT, SPIN, TRICK


var player_top_speed: float

func update_top_speed(speed: float) -> void:
	player_top_speed = speed
	print("Top speed is " + str(player_top_speed))



func play_audio(request: String) -> void:
	request.capitalize()
	match request:
		"DRIVE":
			driving.play()
		"DRIFT":
			#drifting.play()
			pass
		"CHARGE":
			charging.play()
		"SPIN":
			#spinning.play()
			pass
		"CRASH":
			crashing.play()
		"BOOST":
			#boosting.play()
			pass
		"TRICK":
			tricking.play()
		_:
			print("AudioError: Tried to play Audio that isn't defined")

func stop_audio(request: String) -> void:
	request.capitalize()
	match request:
		"DRIVE":
			driving.stop()
		"DRIFT":
			pass
		"SPIN":
			pass
		"CRASH":
			crashing.stop()
		"BOOST":
			#boosting.stop()
			pass
		_:
			print("AudioError: Tried to play Audio that isn't defined")

#MOSTLY FOR DRIVE AT THE MOMENT SCALE IS FROM 0.5 TO 2.0
func bend_pitch(request: String, modifier: float) -> void:
	request.capitalize()
	match request:
		"DRIVE":
			var _min = 0.4 #Minimum pitch bend value
			modifier = (modifier/player_top_speed) * 0.6 + _min
			if modifier > 1.05:
				modifier += 0.3 # Boosts are more noticable
			driving.volume_db = -24.0 + modifier * 5
			driving.pitch_scale = modifier
		"CHARGE":
			modifier = (modifier/20) + 0.8
			charging.pitch_scale = modifier
		_:
			print("AudioError: Tried to bend pitch of undefined sound")
