extends UIState

@onready var back_button: NavButton = $BackButtonMargin/BackButton
@onready var next_button: NavButton = $NextButtonMargin/NextButton

# buttons
@onready var track_button_1: TextureButton = $VBoxContainer/TrackViewMargin/TrackViewHBox/TrackIcon1/TrackButton
@onready var track_button_2: TextureButton = $VBoxContainer/TrackViewMargin/TrackViewHBox/TrackIcon2/TrackButton
@onready var track_button_3: TextureButton = $VBoxContainer/TrackViewMargin/TrackViewHBox/TrackIcon3/TrackButton
@onready var track_button_4: TextureButton = $VBoxContainer/TrackViewMargin/TrackViewHBox/TrackIcon4/TrackButton

func _ready() -> void:
	self.visibility_changed.connect(_show_back_button)
	
	if GameManager.current_track == GameManager.SelectedTrack.NONE:
		next_button.exit()


func _input(event: InputEvent) -> void:
	if ui_root.current_state != ui_root.State.TRACK_SELECT:
		return
	
	# emit the button pressed with ui_select
	for player : PlayerDefinition in GameManager.player_list:
		if event.is_action(player.controls.actions["forward"]):
			match get_viewport().gui_get_focus_owner():
				track_button_1:
					track_button_1.pressed.emit()
				track_button_2:
					track_button_2.pressed.emit()
		
		# next button pressed
		if event.is_action(player.controls.actions["start"]):
			next_button.pressed.emit()
		
		# deselect goes back
		if event.is_action(player.controls.actions["backwards"]):
			back_button.pressed.emit()
			back_button.hide()
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
