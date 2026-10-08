extends Node3D

@onready var driving: AudioStreamPlayer3D = $DriveSFX
@onready var boosting: AudioStreamPlayer3D = $BoostSFX
@onready var crashing: AudioStreamPlayer3D = $CrashSFX

func play_audio(request: String) -> void:
	request.capitalize()
	match request:
		#"DRIVE":
			#driving.play()
		"DRIFT":
			pass
		"SPIN":
			pass
		"CRASH":
			crashing.play()
		"BOOST":
			boosting.play()
		"TRICK":
			pass
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
			boosting.stop()
		_:
			print("AudioError: Tried to play Audio that isn't defined")
