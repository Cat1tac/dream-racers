class_name PausePanel extends PanelContainer

var main_menu_uid: String = "uid://dt5xamoe48268"

var tween: Tween
var hide_vec2: Vector2 = Vector2(1.0, 0.0)

@onready var resume_button: Button = $MarginContainer/VBoxContainer/ResumeButton
@onready var return_button: Button = $MarginContainer/VBoxContainer/ReturnButton

func _init() -> void:
	GameManager.pause_game.emit()
	offset_transform_enabled = true
	offset_transform_scale = hide_vec2
	
	show_pause_panel()

func _ready() -> void:
	resume_button.grab_focus()
	for button in find_children("*", "Button"):
		button.focus_entered.connect(Audio.play_ui_up)

# handles unpausing
func _input(event: InputEvent) -> void:
	for player : PlayerDefinition in GameManager.player_list:
		if event.is_action_pressed(player.controls.actions["start"]) and GameManager.game_paused:
			#get_viewport().set_input_as_handled()
			print("UNPAUSE")
			hide_pause_panel()
		elif event.is_action_pressed(player.controls.actions["forward"]):
			Audio.play_ui_select()
			match get_viewport().gui_get_focus_owner():
				resume_button:
					resume_button.pressed.emit()
				return_button:
					return_button.pressed.emit()

func _resume_button_pressed() -> void:
	hide_pause_panel()
	GameManager.unpause_game.emit()

func _return_button_pressed() -> void:
	GameManager.load_into_path(main_menu_uid)
	# set booleans to reset state
	GameManager.reset_selections()
	GameManager.game_paused = false
	GameManager.toggle_in_match()

#region Tweens
func show_pause_panel() -> void:
	GameManager.game_paused = true
	show()
	_reset_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "offset_transform_scale", Vector2.ONE, 0.3)

func hide_pause_panel() -> void:
	_reset_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "offset_transform_scale", hide_vec2, 0.3)
	await tween.finished
	GameManager.unpause_game.emit()
	GameManager.game_paused = false
	queue_free()

func _reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
#endregion
