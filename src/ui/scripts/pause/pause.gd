class_name PAUSE extends Node

@onready var pause_panel: PackedScene = preload("uid://cty00qgrry1cv")

# checks for pause inputs
func _input(event: InputEvent) -> void:
	for player : PlayerDefinition in GameManager.player_list:
		if event.is_action_pressed(player.controls.actions["start"]) and not GameManager.game_paused:
			print("PAUSE")
			var pause_panel_instance: PausePanel = pause_panel.instantiate()
			pause_panel_instance.set_anchors_preset(Control.PRESET_CENTER)
			add_child(pause_panel_instance)
