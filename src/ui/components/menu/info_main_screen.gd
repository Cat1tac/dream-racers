extends Control
@onready var controls_button : Button = %ControlsButton
@onready var driving_button : Button = %DrivingButton
@onready var interactables_button : Button = %InteractablesButton
@onready var main_menu_uid : String = "uid://dt5xamoe48268"
@onready var sfx: Node = $"../SFX"

var is_in_section : bool = false

## the button that was last in focus
var last_focus : Control

@onready var root: Node = $".."
# SCREENS
@onready var controls_screen : PackedScene = preload("uid://buqdt7lch34oc")
@onready var techinques_screen : PackedScene = preload("uid://bqcc6f4vpylx0")
@onready var interactables_screen : PackedScene = preload("uid://cregn2by6jp8h")

func _ready() -> void:
	controls_button.grab_focus()

func _input(event: InputEvent) -> void:
	if is_in_section:
		return
	for player : PlayerDefinition in GameManager.player_list:
		if player.is_cpu:
			return
		if event.is_action_pressed(player.controls.actions["forward"]):
			sfx.play_ui_select()
			match get_viewport().gui_get_focus_owner():
				controls_button:
					_instantiate_screen(controls_screen)
					last_focus = controls_button
				driving_button:
					_instantiate_screen(techinques_screen)
					last_focus = driving_button
				interactables_button:
					_instantiate_screen(interactables_screen)
					last_focus = interactables_button
		elif Input.is_action_just_pressed(player.controls.actions["backwards"]):
			sfx.play_ui_back()
			GameManager.load_into_path(main_menu_uid, 1)
		elif Input.is_action_just_pressed(player.controls.actions["up"]):
			sfx.play_ui_up()
		elif Input.is_action_just_pressed(player.controls.actions["down"]):
			sfx.play_ui_down()

func _instantiate_screen(screen : PackedScene) -> void:
	var new_screen : InfoScreen = screen.instantiate()
	root.add_child(new_screen)
	new_screen.screen_return.connect(_regrab_focus)
	is_in_section = true

func _regrab_focus() -> void:
	is_in_section = false
	last_focus.grab_focus()
