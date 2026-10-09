extends UIState

@onready var race_button: Button = $VBoxContainer/ButtonMargin/ButtonVBox/RaceButton

func _input(event: InputEvent) -> void:
	if ui_root.current_state != ui_root.State.MAIN_MENU:
		return
		
	for player : PlayerDefinition in GameManager.player_list:
		if event.is_action(player.controls.ui_next):
			race_button.pressed.emit()
