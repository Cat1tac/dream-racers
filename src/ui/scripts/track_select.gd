extends UIState

@onready var back_button: NavButton = $BackButtonMargin/BackButton
@onready var next_button: NavButton = $NextButtonMargin/NextButton

func _ready() -> void:
	self.visibility_changed.connect(_show_back_button)
	
	if GameManager.current_track == GameManager.SelectedTrack.NONE:
		next_button.exit()

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
	GameManager.set_track(GameManager.SelectedTrack.NONE)
	
#endregion
func _show_back_button() -> void:
	back_button.set_onscreen()
func _show_next_button() -> void:
		next_button.enter()
		next_button.grab_focus()
