extends HBoxContainer

func _on_track_1_button_pressed() -> void:
	GameManager.set_track(GameManager.Track.TREE)

func _on_track_2_button_pressed() -> void:
	GameManager.set_track(GameManager.Track.SHIP)

func _on_track_3_button_pressed() -> void:
	pass # Replace with function body.

func _on_track_4_button_pressed() -> void:
	pass # Replace with function body.
