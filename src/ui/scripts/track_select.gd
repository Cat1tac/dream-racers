extends UIState

@export var next_button: Button

func _ready() -> void:
	if GameManager.current_track == GameManager.SelectedTrack.NONE:
		next_button.hide()

func _process(_delta: float) -> void:
	pass

func _track_1_button_pressed() -> void:
	GameManager.set_track(GameManager.SelectedTrack.TREE)
	_show_next_button()

func _track_2_button_pressed() -> void:
	GameManager.set_track(GameManager.SelectedTrack.SHIP)
	_show_next_button()

func _track_3_button_pressed() -> void:
	pass # Replace with function body.

func _track_4_button_pressed() -> void:
	pass # Replace with function body.
	
#region transitions
func _back_button_pressed() -> void:
	next_button.hide()
	GameManager.set_track(GameManager.SelectedTrack.NONE)
	
#endregion
func _show_next_button() -> void:
		if next_button.visible:
			return
		next_button.show()
		next_button.grab_focus()
		transition_animations.play("next_button_pop_in")
