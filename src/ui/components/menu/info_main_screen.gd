extends Control
@onready var controls_button : Button = %ControlsButton
@onready var driving_button : Button = %DrivingButton
@onready var interactables_button : Button = %InteractablesButton
@onready var main_menu_uid : String = "uid://dt5xamoe48268"
@onready var sfx: Node = $"../SFX"

func _ready() -> void:
	controls_button.grab_focus()

func _input(event: InputEvent) -> void:
	for player : PlayerDefinition in GameManager.player_list:
		if player.is_cpu:
			return
		if event.is_action_pressed(player.controls.actions["forward"]):
			sfx.play_ui_select()
			match get_viewport().gui_get_focus_owner():
				controls_button:
					controls_button.pressed.emit()
				driving_button:
					driving_button.pressed.emit()
				interactables_button:
					interactables_button.pressed.emit()
		elif Input.is_action_just_pressed(player.controls.actions["backwards"]):
			sfx.play_ui_back()
			GameManager.load_into_path(main_menu_uid, 1)
