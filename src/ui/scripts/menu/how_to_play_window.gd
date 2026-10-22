extends TabContainer

func _ready() -> void:
	Events.on_how_to_play.emit(false)
	
func _exit_tree() -> void:
	Events.on_how_to_play.emit(true)
	
func _input(event: InputEvent) -> void:
	for player : PlayerDefinition in GameManager.player_list:
		if Input.is_action_just_pressed(player.controls.actions["right"]):
			current_tab = min(current_tab + 1, self.get_child_count() - 1)
		if Input.is_action_just_pressed(player.controls.actions["left"]):
			current_tab = max(current_tab - 1, 0)
		if event.is_action(player.controls.actions["backwards"]):
			queue_free()
