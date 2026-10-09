extends PanelContainer

func _input(event: InputEvent) -> void:
	# emit the button pressed with ui_select
	for player : PlayerDefinition in GameManager.player_list:
		if event.is_action(player.controls.ui_deselect):
			queue_free()
